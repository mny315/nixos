{ pkgs, inputs, ... }:


#User
{
  users.users.mny315 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "gamemode" ];
    packages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      
      google-chrome
      ayugram-desktop
      prismlauncher
      mangohud
      fastfetch
      lm_sensors
      ivm
    ];
  };

#SystemPkgs
  environment.systemPackages = with pkgs; [
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
     
    xwayland-satellite
    papirus-icon-theme
    wl-clip-persist
    wl-clipboard
    file-roller
    neovide 
    neovim
    ffmpeg
    udiskie
    fuzzel
    wezterm
    git
  ];

#Programs  
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };
}
