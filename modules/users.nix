{ pkgs, inputs, ... }:


#User
{
  users.users.mny315 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "gamemode" ];
    packages = with pkgs; [
      
      bibata-cursors
      google-chrome
      kotatogram-desktop
      prismlauncher
      fastfetch
      neovide
      imv
    ];
  };

#SystemPkgs
  environment.systemPackages = with pkgs; [
    
    tela-circle-icon-theme
    vimPlugins.LazyVim
    xwayland-satellite
    wl-clip-persist
    bibata-cursors
    wl-clipboard
    lm_sensors
    file-roller
    libarchive
    hyprshot
    hyprlock
    udiskie
    wezterm
    mangohud
    neovim
    qbittorrent-enhanced
    ffmpeg
    fuzzel
    unrar
    p7zip
    unzip
    zip
    git
      
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

}
