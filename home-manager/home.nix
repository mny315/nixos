{ config, pkgs, inputs, ... }: {
  home.username = "mny315";
  home.homeDirectory = "/home/mny315";
  home.stateVersion = "24.05";

  imports = [
    ./dots.nix
    ./themes.nix
  ];

  programs.home-manager.enable = true;



}
