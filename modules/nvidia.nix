{ config, pkgs, ... }:

#32 bit
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

#Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true; 
    nvidiaSettings = true;
  };

#Environments
 environment.variables = {
#    NIXOS_OZONE_WL = "1";
    
  };
}
