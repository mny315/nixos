{ inputs, lib, pkgs, ... }:

let
  src = inputs.ge77hx-conf;

  msiconf = pkgs.rustPlatform.buildRustPackage {
    pname = "msiconf";
    version = "0.1.0";

    inherit src;

    cargoLock = {
      lockFile = src + "/Cargo.lock";
    };

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.libusb1
    ];

    cargoBuildFlags = [
      "--workspace"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin"
      install -m755 "target/${pkgs.stdenv.hostPlatform.rust.rustcTarget}/release/msiconf" "$out/bin/msiconf"
      install -m755 "target/${pkgs.stdenv.hostPlatform.rust.rustcTarget}/release/msiconfd" "$out/bin/msiconfd"

      runHook postInstall
    '';

    meta = {
      description = "MSI Raider GE77 HX hardware control";
      homepage = "https://github.com/mny315/GE77HX_conf";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      mainProgram = "msiconf";
    };
  };
in
{
  environment.systemPackages = [
    msiconf
  ];

  environment.etc."msiconf/config.toml".source =
    src + "/config.example.toml";

  boot.kernelModules = [
    "ec_sys"
  ];

  boot.extraModprobeConfig = ''
    options ec_sys write_support=1
  '';

  systemd.services.msiconfd = {
    description = "MSIconf hardware control daemon";
    wantedBy = [ "multi-user.target" ];
    wants = [ "sys-kernel-debug.mount" ];
    after = [
      "systemd-modules-load.service"
      "sys-kernel-debug.mount"
    ];

    path = [
      pkgs.coreutils
      pkgs.kmod
    ];

    # ec_sys normally exposes the EC node when it is loaded. On this laptop it
    # can occasionally be present without ec0/io after boot, so repair that
    # state once before starting the daemon. msiconfd itself still retries the
    # backend if the EC becomes available later.
    preStart = ''
      ec_io=/sys/kernel/debug/ec/ec0/io
      reload_ec=0

      if [ ! -d /sys/module/ec_sys ]; then
        modprobe ec_sys write_support=1
      else
        if [ ! -e "$ec_io" ]; then
          reload_ec=1
        elif [ -r /sys/module/ec_sys/parameters/write_support ]; then
          write_support="$(cat /sys/module/ec_sys/parameters/write_support)"
          if [ "$write_support" != Y ] && [ "$write_support" != 1 ]; then
            reload_ec=1
          fi
        fi

        if [ "$reload_ec" -eq 1 ]; then
          if modprobe -r ec_sys; then
            modprobe ec_sys write_support=1
          else
            echo "msiconfd: warning: could not reload ec_sys" >&2
          fi
        fi
      fi

      if [ ! -e "$ec_io" ]; then
        echo "msiconfd: warning: $ec_io is unavailable; daemon will retry" >&2
      fi
    '';

    environment = {
      MSICONF_CONFIG = "/etc/msiconf/config.toml";
      RUST_LOG = "info";
    };

    serviceConfig = {
      Type = "simple";
      User = "root";
      Group = "wheel";
      ExecStart = "${msiconf}/bin/msiconfd";
      Restart = "on-failure";
      RestartSec = "2s";
      RuntimeDirectory = "msiconf";
      RuntimeDirectoryMode = "0750";
      UMask = "0007";
    };
  };
}
