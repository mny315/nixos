{ ... }:

{
  # Modules
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ./ge77hx.nix
    ./hardware.nix
  ];

  # Hostname
  networking.hostName = "laptop";

  # Monitor
  home-manager.extraSpecialArgs.niriOutputConfig = ''
    output "BOE 0x09F9 Unknown" {
        mode "2560x1440@240.003"
        scale 1.25
        focus-at-startup
    }
  '';

  # Locale
  time.timeZone = "UTC";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # NVIDIA
  hardware.nvidia = {
    open = false;
  };
}
