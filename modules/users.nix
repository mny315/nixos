{ pkgs, inputs, ... }:


#UserPkgs
{
  users.users.mny315 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "gamemode" "scanner" "lp" ];
    packages = with pkgs; [
     
      qbittorrent-enhanced 
      bibata-cursors
      google-chrome
      prismlauncher
      fastfetch
      neovide
      tauon
      imv
    ];
  };

#SystemPkgs
  environment.systemPackages = with pkgs; [
     
    fscrypt-experimental
    vimPlugins.LazyVim
    xwayland-satellite
    gnome-disk-utility
    wl-clip-persist
    bibata-cursors
    materialgram
    wl-clipboard
    simple-scan
    file-roller
    libreoffice
    libarchive
    lm_sensors
    alacritty 
    mangohud
    hyprlock
    udiskie
    python3
    neovim
    ffmpeg
    unrar
    _7zz
    unzip
    gimp
    cava
    zip
    git
    imv
  ];

#Programs
  programs.xwayland.enable = true;
  programs.xfconf.enable = true;

programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };

#Fonts
fonts.packages = with pkgs; [
    ibm-plex
    material-design-icons
  ];

#Zsh
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    zsh
  ];

}
