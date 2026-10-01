{ ... }:

{
  # Modules
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/corecycler.nix
    ./hyperx.nix
    ./hardware.nix
  ];

  # Hostname
  networking.hostName = "desktop";

  # Monitor
  home-manager.extraSpecialArgs.niriOutputConfig = ''
    output "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q3 0x01010101" {
        mode "2560x1440@299.999"
        scale 1
        focus-at-startup
    }
  '';

  # NVIDIA
  hardware.nvidia = {
    open = true;

    powerManagement = {
      enable = true;
      kernelSuspendNotifier = true;
    };
  };

  # Locale
  time.timeZone = "Asia/Yekaterinburg";
}
