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

#Kernel tweaks
  boot.kernelParams = [
    "quiet" "splash" "loglevel=5" "udev.log_level=3" "split_lock_detect=off"
 ];

#ForThunar
boot.kernel.sysctl = {
  "vm.dirty_bytes" = 16777216;
  "vm.dirty_background_bytes" = 8388608;
};

#plymouth
  boot.consoleLogLevel = 1;
  boot.initrd.verbose = false;
  
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
}
