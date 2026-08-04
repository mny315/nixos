{ pkgs, ... }:

let
  # IOPaint libraries
  libPath = pkgs.lib.makeLibraryPath (
    [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.libjpeg
      pkgs.libtiff
      pkgs.freetype
      pkgs.lcms2
      pkgs.libwebp
      pkgs.openjpeg
      pkgs.libglvnd
      pkgs.glib
    ]
    ++ pkgs.lib.optional (pkgs ? libxcrypt-legacy) pkgs.libxcrypt-legacy
  );

  # IOPaint
  iopaint-gpu = pkgs.writeShellScriptBin "iopaint-gpu" ''
    set -euo pipefail

    APP_DIR="$HOME/.local/share/iopaint-gpu-py311"
    VENV="$APP_DIR/.venv"
    PORT="''${IOPAINT_PORT:-8080}"
    MODEL="''${IOPAINT_MODEL:-lama}"
    URL="http://127.0.0.1:$PORT"
    SERVER_PID=""
    BROWSER_PROFILE=""
    LOG="$APP_DIR/iopaint-gpu.log"
    WRAPPER_VERSION="9"
    MARKER="$APP_DIR/.wrapper-version"
    REBUILD_LOCK="$APP_DIR/.rebuild.lock"
    REBUILD_LOCK_HELD=0
    IOPAINT_VERSION="''${IOPAINT_VERSION:-1.6.0}"
    TORCH_VERSION="''${TORCH_VERSION:-2.11.0}"
    TORCHVISION_VERSION="''${TORCHVISION_VERSION:-0.26.0}"
    PYTORCH_INDEX_URL="''${PYTORCH_INDEX_URL:-https://download.pytorch.org/whl/cu128}"
    IOPAINT_DEVICE="''${IOPAINT_DEVICE:-cuda}"
    MARKER_CONTENT="$WRAPPER_VERSION|iopaint=$IOPAINT_VERSION|torch=$TORCH_VERSION|torchvision=$TORCHVISION_VERSION|index=$PYTORCH_INDEX_URL"

    cleanup() {
      if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
      fi
      if [ -n "$BROWSER_PROFILE" ]; then
        rm -rf "$BROWSER_PROFILE"
      fi
      if [ "$REBUILD_LOCK_HELD" = "1" ]; then
        rmdir "$REBUILD_LOCK" 2>/dev/null || true
      fi
    }

    trap cleanup EXIT INT TERM

    mkdir -p "$APP_DIR"
    exec >>"$LOG" 2>&1
    echo "[$(date -Is)] starting iopaint-gpu wrapper $WRAPPER_VERSION"
    cd "$APP_DIR"

    export UV_LINK_MODE=copy
    export PIP_PREFER_BINARY=1
    export PYTHONNOUSERSITE=1
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${libPath}:''${LD_LIBRARY_PATH:-}"

    open_existing() {
      echo "iopaint is already listening at $URL; opening existing UI"
      ${pkgs.xdg-utils}/bin/xdg-open "$URL" >/dev/null 2>&1 || true
      exit 0
    }

    if ${pkgs.curl}/bin/curl -fsS "$URL" >/dev/null 2>&1; then
      open_existing
    fi

    venv_ok() {
      [ -x "$VENV/bin/python" ] || return 1
      [ -x "$VENV/bin/iopaint" ] || return 1
      "$VENV/bin/python" - <<'PY' >/dev/null 2>&1
import importlib.util
import sys
for name in ("iopaint", "torch", "torchvision"):
    if importlib.util.find_spec(name) is None:
        sys.exit(1)
PY
    }

    need_rebuild_reason() {
      if [ "''${IOPAINT_REBUILD:-0}" = "1" ]; then
        echo "forced rebuild requested"
        return 0
      fi
      if [ ! -f "$MARKER" ] || [ "$(cat "$MARKER" 2>/dev/null || true)" != "$MARKER_CONTENT" ]; then
        echo "wrapper/dependency versions changed or marker missing"
        return 0
      fi
      if ! venv_ok; then
        echo "venv is broken or incomplete"
        return 0
      fi
      return 1
    }

    acquire_rebuild_lock() {
      while ! mkdir "$REBUILD_LOCK" 2>/dev/null; do
        echo "another iopaint-gpu rebuild is already running; waiting"
        if [ -n "$(${pkgs.findutils}/bin/find "$REBUILD_LOCK" -maxdepth 0 -mmin +120 -print 2>/dev/null || true)" ]; then
          echo "removing stale rebuild lock"
          rm -rf "$REBUILD_LOCK"
          continue
        fi
        sleep 5
      done
      REBUILD_LOCK_HELD=1
    }

    release_rebuild_lock() {
      if [ "$REBUILD_LOCK_HELD" = "1" ]; then
        rmdir "$REBUILD_LOCK" 2>/dev/null || true
        REBUILD_LOCK_HELD=0
      fi
    }

    avif_ok() {
      "$VENV/bin/python" - <<'PY' >/dev/null 2>&1
import pillow_avif.AvifImagePlugin  # noqa: F401
from PIL import Image
raise SystemExit(0 if Image.registered_extensions().get('.avif') == 'AVIF' else 1)
PY
    }

    install_avif_sitecustomize() {
      local site_packages
      site_packages="$($VENV/bin/python - <<'PY'
import site
print(site.getsitepackages()[0])
PY
)"
      cat > "$site_packages/sitecustomize.py" <<'PY'
# Loaded automatically by Python on startup. Registers AVIF support in Pillow for IOPaint.
try:
    import pillow_avif.AvifImagePlugin  # noqa: F401
except Exception:
    pass
PY
    }

    ensure_avif_support() {
      if avif_ok; then
        echo "AVIF support is available"
        return 0
      fi

      echo "installing AVIF support for Pillow"
      "$VENV/bin/python" -m pip install \
        --only-binary=:all: \
        "pillow-avif-plugin>=1.4.6"
      install_avif_sitecustomize

      if avif_ok; then
        echo "AVIF support is available"
      else
        echo "AVIF support is still unavailable after installing pillow-avif-plugin"
        exit 1
      fi
    }

    rebuild_venv_unlocked() {
      echo "rebuilding venv"
      rm -rf "$VENV"

      ${pkgs.uv}/bin/uv venv "$VENV" --python ${pkgs.python311}/bin/python --seed

      "$VENV/bin/python" -m pip install --upgrade pip wheel setuptools

      "$VENV/bin/python" -m pip install \
        --only-binary=:all: \
        "Pillow>=10.4.0" \
        "pillow-avif-plugin>=1.4.6"

      install_avif_sitecustomize

      echo "installing PyTorch from $PYTORCH_INDEX_URL; this is a multi-GB download on first run"
      "$VENV/bin/python" -m pip install \
        "torch==$TORCH_VERSION" \
        "torchvision==$TORCHVISION_VERSION" \
        --index-url "$PYTORCH_INDEX_URL"

      "$VENV/bin/python" -m pip install \
        --prefer-binary \
        "IOPaint==$IOPAINT_VERSION"

      "$VENV/bin/python" - <<'PY'
import pillow_avif.AvifImagePlugin  # noqa: F401
from PIL import Image
import torch
print('torch:', torch.__version__)
print('cuda available:', torch.cuda.is_available())
print('cuda version:', torch.version.cuda)
print('avif registered:', Image.registered_extensions().get('.avif') == 'AVIF')
if torch.cuda.is_available():
    print('cuda device:', torch.cuda.get_device_name(0))
    print('cuda capability:', torch.cuda.get_device_capability(0))
    try:
        x = torch.ones((1,), device='cuda')
        torch.cuda.synchronize()
        print('cuda smoke test: ok')
    except Exception as e:
        print('cuda smoke test failed:', repr(e))
PY

      printf '%s\n' "$MARKER_CONTENT" > "$MARKER"
    }

    ensure_venv() {
      local reason=""
      if ! reason="$(need_rebuild_reason)"; then
        return 0
      fi

      echo "$reason"
      acquire_rebuild_lock

      if reason="$(need_rebuild_reason)"; then
        echo "$reason"
        rebuild_venv_unlocked
      else
        echo "venv was rebuilt by another process"
      fi

      release_rebuild_lock
    }

    ensure_venv
    ensure_avif_support

    "$VENV/bin/iopaint" start \
      --model="$MODEL" \
      --device="$IOPAINT_DEVICE" \
      --host=127.0.0.1 \
      --port="$PORT" &
    SERVER_PID="$!"

    READY=0
    for _ in $(seq 1 120); do
      if ${pkgs.curl}/bin/curl -fsS "$URL" >/dev/null 2>&1; then
        READY=1
        break
      fi
      if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        wait "$SERVER_PID"
        exit $?
      fi
      sleep 1
    done

    if [ "$READY" != "1" ]; then
      echo "server did not become ready at $URL"
      exit 1
    fi

    open_browser_and_wait() {
      BROWSER_PROFILE="$(mktemp -d -t iopaint-browser.XXXXXX)"
      DEFAULT_BROWSER="$(${pkgs.xdg-utils}/bin/xdg-settings get default-web-browser 2>/dev/null || true)"
      BROWSER_PID=""

      run_browser() {
        case "$1" in
          firefox|librewolf)
            "$1" --new-instance --profile "$BROWSER_PROFILE" --new-window "$URL" &
            BROWSER_PID="$!"
            return 0
            ;;
          chromium|google-chrome-stable|google-chrome|brave|brave-browser|vivaldi|vivaldi-stable)
            "$1" \
              --user-data-dir="$BROWSER_PROFILE" \
              --app="$URL" \
              --no-first-run \
              --no-default-browser-check \
              --disable-vulkan &
            BROWSER_PID="$!"
            return 0
            ;;
        esac
        return 1
      }

      BROWSER=""
      case "$DEFAULT_BROWSER" in
        *firefox*) BROWSER="firefox" ;;
        *librewolf*) BROWSER="librewolf" ;;
        *chromium*) BROWSER="chromium" ;;
        *google-chrome*) BROWSER="google-chrome-stable" ;;
        *brave*) BROWSER="brave" ;;
        *vivaldi*) BROWSER="vivaldi" ;;
      esac

      if [ -n "$BROWSER" ] && command -v "$BROWSER" >/dev/null 2>&1 && run_browser "$BROWSER"; then
        wait "$BROWSER_PID" 2>/dev/null || true
        return 0
      fi

      for BROWSER in firefox librewolf chromium google-chrome-stable google-chrome brave brave-browser vivaldi vivaldi-stable; do
        if command -v "$BROWSER" >/dev/null 2>&1 && run_browser "$BROWSER"; then
          wait "$BROWSER_PID" 2>/dev/null || true
          return 0
        fi
      done

      echo "no supported browser found in PATH, falling back to xdg-open"
      ${pkgs.xdg-utils}/bin/xdg-open "$URL" >/dev/null 2>&1 || true
      wait "$SERVER_PID" 2>/dev/null || true
    }

    open_browser_and_wait
  '';

  # IOPaint icon
  iopaint-gpu-icon = pkgs.writeTextFile {
    name = "iopaint-gpu-icon";
    destination = "/share/icons/hicolor/scalable/apps/iopaint-gpu.svg";
    text = ''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
        <defs>
          <linearGradient id="bg" x1="16" y1="112" x2="112" y2="16" gradientUnits="userSpaceOnUse">
            <stop stop-color="#2d2a55"/>
            <stop offset="1" stop-color="#7c5cff"/>
          </linearGradient>
          <linearGradient id="brush" x1="42" y1="88" x2="95" y2="35" gradientUnits="userSpaceOnUse">
            <stop stop-color="#f6d365"/>
            <stop offset="1" stop-color="#fda085"/>
          </linearGradient>
        </defs>
        <rect width="128" height="128" rx="28" fill="url(#bg)"/>
        <path d="M31 90c11 8 25 7 34-2 6-6 5-17-3-22-9-6-20-1-24 9-2 5-4 10-7 15Z" fill="#ffffff" opacity="0.92"/>
        <path d="M58 70 91 37c6-6 15 3 9 9L67 79c-4 4-13-5-9-9Z" fill="url(#brush)"/>
        <circle cx="90" cy="38" r="7" fill="#fff3b0" opacity="0.95"/>
        <path d="M35 31h29M35 45h18M81 86h16" stroke="#ffffff" stroke-width="8" stroke-linecap="round" opacity="0.75"/>
      </svg>
    '';
  };

  # IOPaint desktop entry
  iopaint-gpu-desktop = pkgs.makeDesktopItem {
    name = "iopaint-gpu";
    desktopName = "IOPaint GPU";
    genericName = "AI image inpainting";
    comment = "Start IOPaint with CUDA support and open the web interface";
    exec = "${iopaint-gpu}/bin/iopaint-gpu";
    icon = "iopaint-gpu";
    terminal = false;
    categories = [ "Graphics" "Photography" ];
  };
in
{
  # IOPaint packages
  home.packages = [
    iopaint-gpu
    iopaint-gpu-desktop
    iopaint-gpu-icon
    pkgs.uv
    pkgs.curl
    pkgs.xdg-utils
    pkgs.findutils
  ];
}
