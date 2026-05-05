{ pkgs, lib, ... }:

{

#Sound
security.rtkit.enable = true;
services.pulseaudio.enable = false;

services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  wireplumber.enable = true;

  extraConfig.pipewire."92-audio-stability" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.allowed-rates" = [ 48000 ];

      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 1024;
      "default.clock.max-quantum" = 4096;
    };
  };

  wireplumber.extraConfig."92-disable-audio-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "~alsa_output.*";
          }
        ];

        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };
};

#Bluetooth
hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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




#Network
  networking = { 
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
    power-profiles-daemon.enable = true;
    fstrim.enable = true;
    hypridle.enable = true;

#Dm
    greetd = {
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
  };
}
