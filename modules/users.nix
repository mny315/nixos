{ pkgs, inputs, ... }:

{
  users.users.mny315 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "gamemode" ];
    packages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      
      google-chrome ayugram-desktop imv prismlauncher
      mangohud fastfetch lm_sensors
    ];
  };

  environment.systemPackages = with pkgs; [
    git neovide neovim 
    ffmpeg udiskie
 #   (mpv.override { scripts = [ mpvScripts.mpris ]; })
    file-roller
    
    wl-clipboard xwayland-satellite
    grim swww slurp satty fuzzel wezterm
    
    papirus-icon-theme
  ];

  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };
  
  programs.niri.enable = true;
  programs.xwayland.enable = true;
}
