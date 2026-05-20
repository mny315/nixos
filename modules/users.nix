{ pkgs, inputs, ... }:


#UserPkgs
{
  users.users.mny315 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "gamemode" ];
    packages = with pkgs; [
     
      qbittorrent-enhanced 
      kotatogram-desktop
      bibata-cursors
      google-chrome
      prismlauncher
      fastfetch
      neovide
      blender
      tauon
      imv
    ];
  };

#SystemPkgs
  environment.systemPackages = with pkgs; [
     
    vimPlugins.LazyVim
    xwayland-satellite
    gnome-disk-utility
    wl-clip-persist
    bibata-cursors
    wl-clipboard
    file-roller
    libarchive
    lm_sensors
    alacritty
    mangohud
    hyprlock
    udiskie
    neovim
    ffmpeg
    unrar
    p7zip
    unzip
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
    lexend
    intel-one-mono
    material-design-icons
  ];

#Zsh
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    zsh
  ];

}
