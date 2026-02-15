{ config, pkgs, ... }:

{
  fileSystems."/run/media/mny315/games" = {
    device = "/dev/disk/by-uuid/83ef118c-b566-4953-8052-9c7030aab822";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-gvfs-show" ];
  };

  boot.supportedFilesystems = [ 
    "ntfs" "exfat" "vfat" "ext4" "btrfs" "xfs" "f2fs"
  ];

  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
    packages = [ "ru.linux_gaming.PortProton" ];
    uninstallUnmanaged = true;
    overrides = {
      "ru.linux_gaming.PortProton".Context.filesystems = [ "/games" ];
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
      extraProfile = ''
        export PULSE_LATENCY_MSEC=80
      '';
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib fuse3 icu nss openssl curl expat
      libuuid libusb1 libxml2 libGL libxcrypt
      util-linux glib gtk3 pango cairo gdk-pixbuf
      atk dbus libdrm mesa libxkbcommon
      libX11 libXcursor libXcomposite
      libXdamage libXext libXfixes
      libXi libXrender libXtst
      libxcb libXres
      libpulseaudio libthai
    ];
  };
}
