{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelParams = [
    "amd_pstate=guided"
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;


  hardware.i2c.enable = true;
  users.users.mny315.extraGroups = [ "i2c" ];

  services.power-profiles-daemon.enable = true;

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ext4";
    options = [ "nofail" "x-gvfs-show" ];
  };

#Bluetooth
hardware.bluetooth = {
  enable = false;
  powerOnBoot = false;
};

boot.blacklistedKernelModules = [
  "btusb"
];

#HyprX
services.udev.extraRules = ''
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="06be", MODE="0666"
  KERNEL=="hidraw*", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="06be", MODE="0666"
'';



}
