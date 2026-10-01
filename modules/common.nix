{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./services.nix
    ./users.nix
    ./vless.nix
    ./portprotonqt.nix
  ];

  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
    nrsu = "(cd /etc/nixos && nix flake update && sudo nixos-rebuild switch --flake .#$(hostname))";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
  };

  environment.systemPackages = [ pkgs.nano ];
}
