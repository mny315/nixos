{ pkgs,lib,... }:

{

#Sound
security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

#Portals
xdg.portal = {
    enable = true;
      config = {
      common.default = [ "gtk" ];
      niri.default = lib.mkForce [ "gtk" ]; 
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

#Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

#Network
  networking = {
    hostName = "nixos"; 
    networkmanager.enable = true;
  };

#Services
  services = {
    upower.enable = true;
    libinput.enable = true; 
    dbus.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    power-profiles-daemon.enable = false;
    gnome.gnome-keyring.enable = true;
  };

  programs.xfconf.enable = true;

#laptop fan (MSI EC)
  systemd.services.msi-ec-fan-control = {
    description = "MSI EC Advanced Fan Mode";
    after = [ "multi-user.target" "post-resume.target" ];
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    path = [ pkgs.coreutils pkgs.bash ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "msi-advanced-fix" ''
        sleep 1
        echo -ne '\x8d' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0xd4)) conv=notrunc
        echo -ne '\x28\x30\x38\x3f\x4b\x55' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x6a)) conv=notrunc
        echo -ne '\x1e\x1e\x1e\x28\x2f\x41\x64' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x72)) conv=notrunc
        echo -ne '\x28\x2d\x37\x41\x4b\x55' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x82)) conv=notrunc
        echo -ne '\x00\x00\x00\x28\x32\x41\x64' | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=$((0x8a)) conv=notrunc
      '';
      RemainAfterExit = true;
    };
  };

}
