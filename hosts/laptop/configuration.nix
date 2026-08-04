{ pkgs, ... }:

{
  # Modules
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/services.nix
    ../../modules/users.nix
    ../../modules/portprotonqt.nix
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

  # State version
  system.stateVersion = "25.05";

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;
  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  # Shell aliases
  environment.shellAliases = {
    nrs = "cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#$(hostname)";
    nrsu = "cd /etc/nixos && git add . && nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
  };

  # Nano
  environment.systemPackages = [ pkgs.nano ];
}
