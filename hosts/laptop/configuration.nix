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

  # --- Общие системные настройки  ----

  # Версия системы
  system.stateVersion = "25.05";

  # Проприетарщина
  nixpkgs.config.allowUnfree = true;

  # Настройки Nix и Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Время и Локализация
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Алиасы
  environment.shellAliases = {
    f = "sudo nano /etc/nixos/hosts/laptop/configuration.nix";
    nrs = "cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#laptop";
    erase = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
    fniri = "sudo nano /etc/nixos/home-manager/dotfiles/config.kdl";
    fusers = "sudo nano /etc/nixos/modules/users.nix"; 
 };

  # Редактор на случай отвала
  environment.systemPackages = [ pkgs.nano ];
}
