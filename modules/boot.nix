{ pkgs, ... }:

{
  # Boot
  boot = {
    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=5"
      "udev.log_level=3"
    ];

    consoleLogLevel = 1;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "spinner";
    };
  };
}
