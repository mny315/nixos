{ pkgs, inputs, ... }:

let
  # Python
  python = pkgs.python3;

  # Python environment
  pythonEnv = python.withPackages (ps: with ps; [
    babel
    dbus-fast
    evdev
    libarchive-c
    orjson
    pefile
    pillow
    psutil
    pyside6
    pygame
    qrcode
    rapidfuzz
    requests
    tqdm
    vdf
    websocket-client
  ]);

  # Runtime dependencies
  runtimeDeps = with pkgs; [
    bash
    bluez
    cabextract
    coreutils
    curl
    exiftool
    file
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gzip
    libnotify
    lsof
    mesa-demos
    networkmanager
    p7zip
    pciutils
    procps
    psmisc
    pulseaudio
    rsync
    squashfsTools
    udisks2
    unzip
    upower
    util-linux
    wget
    which
    xdg-utils
    xz
    zenity
    zstd
  ];

  # Steam Run
  steamRun = (pkgs.steam.override {
    extraPkgs = _: runtimeDeps;
    # Desktop launchers and CLI callers may pass files located in host /tmp.
    privateTmp = false;
  }).run;

  # Enter from a directory visible to bwrap, then restore the caller's working
  # directory inside the FHS environment. Its host /etc is exposed at /.host-etc.
  # Keep arguments unchanged, including relative filenames and game options.
  portprotonFhs = pkgs.writeShellScript "portproton-fhs" ''
    set -euo pipefail
    original_dir="$PWD"
    cd "''${HOME:-/tmp}"
    export PORTPROTON_NIX_STEAM_RUN=1
    exec ${steamRun}/bin/steam-run ${pkgs.runtimeShell} -c '
      set -e
      case "$1" in
        /etc|/etc/*) cd -- "/.host-etc''${1#/etc}" ;;
        *) cd -- "$1" ;;
      esac
      shift
      exec "$@"
    ' portproton-fhs "$original_dir" "$@"
  '';

  # PortProtonQt
  portprotonqt = pkgs.stdenv.mkDerivation {
    pname = "portprotonqt";
    version = "1.3.1";
    src = inputs.portprotonqt-src;

    nativeBuildInputs = [
      pkgs.meson
      pkgs.ninja
      pkgs.pkg-config
      pkgs.qt6.wrapQtAppsHook
      pythonEnv
    ];

    buildInputs = [
      pkgs.vulkan-loader
      pkgs.qt6.qtbase
      pkgs.qt6.qtimageformats
      pkgs.qt6.qtsvg
    ];

    dontWrapQtApps = true;

    mesonFlags = [
      "-Dpython_purelibdir=${python.sitePackages}"
      "-Dudev_rulesdir=lib/udev/rules.d"
    ];

    postInstall = ''
      # Keep the upstream Python entry point unchanged and expose one public
      # launcher that enters Steam's FHS environment.
      mkdir -p "$out/libexec"
      mv "$out/bin/portprotonqt" "$out/libexec/portprotonqt"

      # Meson installs the entry point with the plain Python interpreter.
      # Runtime Python modules live in pythonEnv, so make the entry point use
      # that interpreter instead of trying to reconstruct its PYTHONPATH.
      sed -i '1c\#!${pythonEnv}/bin/python3' "$out/libexec/portprotonqt"

      # steam-run already provides the outer FHS runtime on NixOS. PortProton
      # normally starts its own pressure-vessel runtime as well; nesting that
      # inside steam-run is fragile and can make game processes die instantly.
      # Force PortProton's runtime off only when launched through our wrapper.
      substituteInPlace "$out/share/portproton/scripts/functions_helper" \
        --replace-fail \
        'pw_init_runtime () {' \
        $'pw_init_runtime () {\n  if [[ "''${PORTPROTON_NIX_STEAM_RUN:-0}" == 1 ]]; then\n    export PW_USE_RUNTIME=0\n  fi'

      # Use the desktop file shipped by upstream. Only make Exec generation-
      # exact instead of maintaining a second copy in Home Manager.
      substituteInPlace \
        "$out/share/applications/ru.linux_gaming.PortProtonQt.desktop" \
        --replace-fail \
        "Exec=portprotonqt %u" \
        "Exec=$out/bin/portprotonqt %u"
    '';

    preFixup = ''
      # wrapQtAppsHook does not auto-wrap Python scripts, so wrap the real
      # upstream entry point explicitly. This supplies the Qt runtime paths
      # without duplicating Qt internals by hand.
      wrapQtApp "$out/libexec/portprotonqt" \
        --prefix PYTHONPATH : "$out/${python.sitePackages}" \
        --prefix PATH : "${pythonEnv}/bin"

      # Share the FHS entry helper so every launcher preserves relative paths.
      cat > "$out/bin/portprotonqt" <<EOF
#!${pkgs.runtimeShell}
export APPDIR="$out"
exec ${portprotonFhs} "$out/libexec/portprotonqt" "\$@"
EOF
      chmod +x "$out/bin/portprotonqt"

      # Generic helper: execute an arbitrary command in the exact same Steam
      # FHS environment used by PortProtonQt itself. This is useful on NixOS
      # for diagnostics against PortProton-managed Proton/Wine runners.
      ln -s ${portprotonFhs} "$out/bin/portproton-fhs"

      # Convenience helper for a PortProton Wine runner and prefix:
      #   portproton-wine GE-PROTON11-1 CLEAR reg query 'HKLM\\...'
      # It deliberately resolves paths at runtime from the user's XDG config
      # directory instead of baking one user's home path into the Nix store.
      cat > "$out/bin/portproton-wine" <<EOF
#!${pkgs.runtimeShell}
set -euo pipefail

if [ "\$#" -lt 3 ]; then
  echo "usage: portproton-wine <runner> <prefix> <wine-command> [args...]" >&2
  echo "example: portproton-wine GE-PROTON11-1 CLEAR reg query 'HKLM\\Software\\Microsoft\\WindowsRuntime'" >&2
  exit 2
fi

runner="\$1"
prefix="\$2"
shift 2

data_root="\$HOME/.config/data"
if [ -n "\''${XDG_CONFIG_HOME:-}" ]; then
  data_root="\$XDG_CONFIG_HOME/data"
fi

runner_root="\$data_root/dist/\$runner"
prefix_root="\$data_root/prefixes/\$prefix"
wine="\$runner_root/files/bin/wine"

if [ ! -x "\$wine" ]; then
  echo "portproton-wine: Wine runner not found: \$wine" >&2
  exit 1
fi

if [ ! -d "\$prefix_root" ]; then
  echo "portproton-wine: prefix not found: \$prefix_root" >&2
  exit 1
fi

exec ${portprotonFhs} env WINEPREFIX="\$prefix_root" "\$wine" "\$@"
EOF
      chmod +x "$out/bin/portproton-wine"
    '';

    postFixup = ''
      test -x "$out/bin/portprotonqt"
      test -x "$out/bin/portproton-fhs"
      test -x "$out/bin/portproton-wine"
      test -x "$out/libexec/portprotonqt"
      test -f "$out/${python.sitePackages}/portprotonqt/app.py"
      test -f "$out/share/applications/ru.linux_gaming.PortProtonQt.desktop"
      test -x "$out/share/portproton/scripts/start.sh"
      test -f "$out/share/portproton/scripts/functions_helper"
      grep -Fq 'PORTPROTON_NIX_STEAM_RUN' \
        "$out/share/portproton/scripts/functions_helper"

      # Catch the otherwise silent startup failure where PortProtonQt cannot
      # locate the start.sh that Meson installed into this Nix output.
      APPDIR="$out" \
        PYTHONPATH="$out/${python.sitePackages}" \
        ${pythonEnv}/bin/python3 -c \
        'from portprotonqt.config import get_portproton_start_command; assert get_portproton_start_command() == ["'$out'/share/portproton/scripts/start.sh"]'

      # Visible marker so it is trivial to verify that this exact revision was
      # installed instead of an older store path.
      mkdir -p "$out/share/portprotonqt"
      printf '%s\n' 'nix-wrapper-fix-v8-preserve-cwd' > "$out/share/portprotonqt/nix-wrapper-revision"

      # wrapQtApp moves the real script to .portprotonqt-wrapped. Verify that
      # the runtime entry point really uses the Python environment containing
      # PySide6, rather than merely testing pythonEnv in isolation.
      test "$(head -n 1 "$out/libexec/.portprotonqt-wrapped")" = \
        '#!${pythonEnv}/bin/python3'

      PYTHONPATH="$out/${python.sitePackages}" \
        ${pythonEnv}/bin/python3 -c \
        "import PySide6, pygame, babel, portprotonqt; import portprotonqt.localization"

      # PortProton shell helpers invoke `python3 -m portprotonqt...` directly.
      # Ensure the Qt wrapper exports pythonEnv first in PATH so those child
      # processes do not fall back to the host/FHS Python without Babel.
      grep -Fq '${pythonEnv}/bin' "$out/libexec/portprotonqt"
    '';

    doCheck = false;

    meta = {
      description = "PortProtonQt built from source and run in Steam's FHS environment";
      homepage = "https://github.com/Boria138/PortProtonQt";
      license = pkgs.lib.licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      mainProgram = "portprotonqt";
    };
  };
in
{

  # PortProtonQt group
  users.groups.portprotonqt = { };

  # PortProtonQt user
  users.users.mny315 = {
    packages = [ portprotonqt ];
    extraGroups = [ "portprotonqt" ];
  };

  # PortProtonQt udev
  services.udev.packages = [ portprotonqt ];

  # PortProtonQt polkit
  security.polkit = {
    enable = true;
    extraConfig = builtins.readFile
      "${inputs.portprotonqt-src}/build-aux/share/polkit-1/rules.d/ru.linux_gaming.PortProtonQt.rules";
  };
}
