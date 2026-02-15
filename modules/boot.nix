{ pkgs, config, ... }:

{
 
#Bootloader
  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
  };

  #Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "ec_sys" "msi-ec" "usbhid" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];

#Kernel tweaks
  boot.kernelParams = [
    "quiet" "splash" "loglevel=4"

#Perfomance !important for laptop!
    "preempt=full" "intel_pstate=active" # "pcie_aspm=force"
#Intel Graphics
    "i915.fastboot=1"
    "i915.enable_guc=2"
    "i915.modeset=1"
    "i915.enable_psr=0"
    "i915.enable_fbc=1"    
#EC Fan control
 #   "i2c-i801.disable_features=0x10"
 #   "ec_sys.write_support=1"
    # Nvidia
#   "nvidia-drm.modeset=1"
    ];

#Modules
#  boot.extraModprobeConfig = ''
#    options msi_ec force=1 model=MS-17K5
#    options nvidia "NVreg_EnableS0ixPowerManagement=1"
# '';

  # --- PLYMOUTH ---
  boot.consoleLogLevel = 1;
  boot.initrd.verbose = false;
  
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
}
