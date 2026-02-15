{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/games.nix 
    ../../modules/nvidia.nix
    ../../modules/services.nix
    ../../modules/users.nix
    ../../modules/SDDM.nix
  ];

#System version
  system.stateVersion = "25.05";

#Proptietary
  nixpkgs.config.allowUnfree = true;

#Flakes (God save us)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#Time
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

#Alias
  environment.shellAliases = {
    nrs = "cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#laptop";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
 };

#Nano for emergency
  environment.systemPackages = [ pkgs.nano ];
}
