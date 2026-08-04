{ ... }:

{
  # AMD
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelParams = [
    "amd_pstate=guided"
  ];

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;


  # I2C
  hardware.i2c.enable = true;
  users.users.mny315.extraGroups = [ "i2c" ];

  # Games
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ext4";
    options = [ "nofail" "x-gvfs-show" ];
  };

#Bluetooth
hardware.bluetooth = {
  enable = true;
  powerOnBoot = false;
};


#HyperX
services.hyperx-cloud-3-switchd.enable = true;

#boot.blacklistedKernelModules = [
#  "btusb"
#];

}
