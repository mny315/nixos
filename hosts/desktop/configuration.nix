{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/games.nix 
    ../../modules/services.nix
    ../../modules/users.nix
 #   ../../modules/vless.nix
    ./HyperX.nix
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


#Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true; 
    nvidiaSettings = true;
  };


#Time
  time.timeZone = "Asia/Yekaterinburg"; 
  i18n.defaultLocale = "en_US.UTF-8";

#Alias
environment.shellAliases = {
    nrs = "cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#$(hostname)";
    nrsu = "cd /etc/nixos && git add . && nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)"; 
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
    VlessOn = "sudo systemctl start sing-box";
    VlessOff = "sudo systemctl stop sing-box && sudo systemctl restart NetworkManager";
    };
#Nano for emergency
  environment.systemPackages = [ pkgs.nano ];
}
