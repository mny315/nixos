{ config, pkgs, ... }:

{
  #boot
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "ec_sys" "msi-ec" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
  boot.kernelParams = [
    "preempt=full"
    "i915.enable_guc=3"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "ec_sys.write_support=1"
  ];

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

#services
  services.power-profiles-daemon.enable = true;

#SystemdStuck
  systemd.settings = {
    Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };


#fan control
systemd.services.msi-ec-fan-control = {
  description = "Smart MSI EC Fan Control";
  after = [ "multi-user.target" "post-resume.target" ];
  wantedBy = [ "multi-user.target" "post-resume.target" ];
  path = with pkgs; [ coreutils bash xxd ];

  serviceConfig = {
    Type = "oneshot";
    ExecStart = pkgs.writeShellScript "msi-smart-fix" ''
      set -e
      [ -f /sys/kernel/debug/ec/ec0/io ] || exit 0

      CURRENT_MODE=$(dd if=/sys/kernel/debug/ec/ec0/io bs=1 skip=$((0xd4)) count=1 2>/dev/null | xxd -p)

      if [ "$CURRENT_MODE" != "8d" ]; then
        echo "Applying MSI Fan Curve (Current: $CURRENT_MODE)..."

        echo -ne '\x8d' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0xd4)) conv=notrunc

        echo -ne '\x28\x30\x38\x3f\x4b\x55' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x6a)) conv=notrunc
        echo -ne '\x1e\x1e\x1e\x23\x2f\x41\x64' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x72)) conv=notrunc

        echo -ne '\x28\x2d\x37\x41\x4b\x55' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x82)) conv=notrunc
        echo -ne '\x00\x00\x00\x23\x32\x41\x64' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x8a)) conv=notrunc
      fi
    '';
    RemainAfterExit = true;
  };
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
