{ pkgs, ... }:

{
  # User
  users.users.mny315 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "gamemode"
      "scanner"
      "lp"
    ];

    packages = with pkgs; [
      # Applications
      google-chrome
      imv
      neovide
      prismlauncher
      qbittorrent-enhanced
      tauon

      # Utilities
      fastfetch
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Desktop integration
    file-roller
    gnome-disk-utility
    hyprlock
    materialgram
    simple-scan
    udiskie
    wl-clip-persist
    wl-clipboard
    xwayland-satellite

    # Applications
    libreoffice

    # Media and hardware tools
    ffmpeg
    lm_sensors

    # Archives and filesystems
    _7zz
    fscrypt-experimental
    libarchive
    unrar
    unzip
    zip

    # Development and runtime tools
    git
    python3
  ];

  programs = {
    # Thunar
    thunar = {
      enable = true;
      plugins = [
        pkgs.thunar-archive-plugin
        pkgs.thunar-volman
      ];
    };

    # Xfconf
    xfconf.enable = true;
    # Zsh
    zsh.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    ibm-plex
    material-design-icons
  ];

  # Zsh
  environment.shells = [ pkgs.zsh ];
}
