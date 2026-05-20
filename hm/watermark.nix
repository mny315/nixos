{ pkgs, ... }:

let
  python = pkgs.python311;

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

    cleanup() {
      if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
      fi
      if [ -n "$BROWSER_PROFILE" ]; then
        rm -rf "$BROWSER_PROFILE"
      fi
    }

    trap cleanup EXIT INT TERM

    mkdir -p "$APP_DIR"
    exec >>"$LOG" 2>&1
    echo "[$(date -Is)] starting iopaint-gpu wrapper v3"
    cd "$APP_DIR"

    export UV_LINK_MODE=copy
    export PIP_PREFER_BINARY=1

    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.libjpeg
      pkgs.libtiff
      pkgs.freetype
      pkgs.lcms2
      pkgs.libwebp
      pkgs.openjpeg
      pkgs.libGL
      pkgs.glib
    ]}:''${LD_LIBRARY_PATH:-}"

    open_existing() {
      echo "iopaint is already listening at $URL; opening existing UI"
      ${pkgs.xdg-utils}/bin/xdg-open "$URL" >/dev/null 2>&1 || true
      exit 0
    }

    if ${pkgs.curl}/bin/curl -fsS "$URL" >/dev/null 2>&1; then
      open_existing
    fi

    if [ ! -x "$VENV/bin/iopaint" ]; then
      rm -rf "$VENV"

      ${pkgs.uv}/bin/uv venv "$VENV" --python ${python}/bin/python --seed

      "$VENV/bin/python" -m pip install --upgrade pip wheel setuptools

      "$VENV/bin/python" -m pip install \
        --only-binary=:all: \
        "Pillow>=10.4.0"

      "$VENV/bin/python" -m pip install \
        torch torchvision \
        --index-url https://download.pytorch.org/whl/cu128

      "$VENV/bin/python" -m pip install \
        --prefer-binary \
        iopaint
    fi

    "$VENV/bin/iopaint" start \
      --model="$MODEL" \
      --device=cuda \
      --host=127.0.0.1 \
      --port="$PORT" &
    SERVER_PID="$!"

    for _ in $(seq 1 120); do
      if ${pkgs.curl}/bin/curl -fsS "$URL" >/dev/null 2>&1; then
        break
      fi
      if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        wait "$SERVER_PID"
        exit $?
      fi
      sleep 1
    done

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
            "$1" --user-data-dir="$BROWSER_PROFILE" --app="$URL" --no-first-run --no-default-browser-check &
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
  home.packages = [
    iopaint-gpu
    iopaint-gpu-desktop
    iopaint-gpu-icon
    pkgs.uv
    pkgs.curl
    pkgs.xdg-utils
  ];
}
