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
}
