{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/games.nix 
    ../../modules/nvidia.nix
    ../../modules/services.nix
    ../../modules/users.nix
    ./hardware.nix
  ];

#hostname
networking.hostName = "desktop";

#System version
  system.stateVersion = "25.05";

#Proptietary
  nixpkgs.config.allowUnfree = true;

#Flakes (God save us)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#Time
  time.timeZone = "Asia/Yekaterinburg"; 
  i18n.defaultLocale = "en_US.UTF-8";

#Alias
environment.shellAliases = {
    nrs = "cd /etc/nixos && sudo nixos-rebuild switch --flake .#$(hostname)";
    nrsu = "cd /etc/nixos && nix flake update && sudo nixos-rebuild boot --flake .#$(hostname)";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
  };

#Nano for emergency
  environment.systemPackages = [ pkgs.nano ];
}
