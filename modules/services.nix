{ pkgs, ... }:

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
    xdgOpenUsePortal = false;
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

  # Greetd
services.greetd = {
  enable = true;
  settings = {
    terminal = {
      vt = 1;
    };

    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --cmd niri-session";
      user = "greeter";
    };
  };
};

  #Steam
programs.steam = {
  enable = true;

  package = pkgs.steam.override {
    extraArgs = "-system-composer";
  };

  gamescopeSession.enable = true;
};

  # Pantum
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      pantum-driver
      sane-airscan
    ];
  };

# CUPS
services.printing = {
  enable = true;
  drivers = with pkgs; [
    pantum-driver
    cups-filters
  ];
};

# IPP USB
services.ipp-usb.enable = true;

# Avahi
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

# Printer group
users.users.mny315.extraGroups = [ "lpadmin" ];

# Printing tools
environment.systemPackages = with pkgs; [
  system-config-printer
  cups
];

}
