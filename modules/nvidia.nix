{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false; 
    nvidiaSettings = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "pci@0000:00:02:0"; 
      nvidiaBusId = "pci@0000:01:00:0";
    };
  };

  systemd.services.nvidia-gpu-clocks = {
    description = "Lock NVIDIA GPU clocks";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi -lgc 0,1395";
      ExecStop = "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi -rgc";
      RemainAfterExit = true;
    };
  };
  
 environment.variables = {
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "iHD";
    WLR_DRM_DEVICES = "/dev/dri/card0";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
   #MANGOHUD = "1";
  };
}
