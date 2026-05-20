{ config, pkgs, inputs, ... }: {
  home.username = "mny315";
  home.homeDirectory = "/home/mny315";
  home.stateVersion = "24.05";

  imports = [
    ./dots.nix
    ./themes.nix
    ./niri.nix
    ./apps.nix
    ./thunar.nix
    ./obsidian-shell.nix
    ./watermark.nix
  ];

  programs.home-manager.enable = true;
  programs.obsidian-shell.enable = true;

}
