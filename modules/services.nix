{ pkgs, lib, ... }:

{
  # Sound
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Portals
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      niri.default = lib.mkForce [ "gtk" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  # Network
  networking.networkmanager.enable = true;

  # Services
  services.upower.enable = true;
  services.libinput.enable = true;
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fstrim.enable = true;
  services.hypridle.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 1;
      };

      initial_session = {
        command = "niri-session";
        user = "mny315";
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Pantum
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      pantum-driver
      sane-airscan
    ];
  };

services.printing = {
  enable = true;
  drivers = with pkgs; [
    pantum-driver
    cups-filters
  ];
};

services.ipp-usb.enable = true;

services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

users.users.mny315.extraGroups = [ "lpadmin" ];

environment.systemPackages = with pkgs; [
  system-config-printer
  cups
];

nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (pkgs.lib.getName pkg) [
    "pantum-driver"
  ]; 

}
