{ config, pkgs, ... }:

{
  #boot
#  boot.initrd.kernelModules = [ "i915" ];
#  boot.kernelModules = [ "ec_sys" "msi-ec" ];
#  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
#  boot.kernelParams = [
#    "preempt=full"
#    "i915.enable_guc=3"
#    "i915.enable_psr=1"
#    "i915.enable_fbc=1"
#    "ec_sys.write_support=1"
#  ];

#intel pkgs
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
    intel-compute-runtime
  ];

#nvidia prime
hardware.nvidia.prime = {
  offload.enable = true;
  offload.enableOffloadCmd = true;

  intelBusId = "PCI:0@0:2:0";
  nvidiaBusId = "PCI:1@0:0:0";
};

#environment
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };


#Nvidia Lock Clock
  systemd.services.nvidia-gpu-clocks = {
    description = "Lock NVIDIA GPU clocks";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi -lgc 0,1200";
      ExecStop = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi -rgc";
      RemainAfterExit = true;
    };
  };



}
