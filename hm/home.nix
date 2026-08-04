{ ... }: {
  # Home
  home.username = "mny315";
  home.homeDirectory = "/home/mny315";
  home.stateVersion = "24.05";

  # Modules
  imports = [
    ./dots.nix
    ./themes.nix
    ./niri.nix
    ./apps.nix
    ./thunar.nix
    ./mimeapps.nix
    ./watermark.nix
  ];

  # Home Manager
  programs.home-manager.enable = true;

}
