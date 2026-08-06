{ pkgs, ... }:

{
  # Modules
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/services.nix
    ../../modules/users.nix
    ../../modules/vless.nix
    ../../modules/portprotonqt.nix
    ../../modules/hyperx.nix
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

  # State version
  system.stateVersion = "25.05";

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;
  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  # Locale
  time.timeZone = "Asia/Yekaterinburg";
  i18n.defaultLocale = "en_US.UTF-8";

  # Shell aliases
  environment.shellAliases = {
    nrs = "cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#$(hostname)";
    nrsu = "cd /etc/nixos && git add . && nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
  };

  # Nano
  environment.systemPackages = [ pkgs.nano ];
}
