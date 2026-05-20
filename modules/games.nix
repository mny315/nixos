{ config, pkgs, ... }:

{



boot.supportedFilesystems = [ 
    "ntfs" "exfat" "vfat" "ext4" "btrfs" "xfs" "f2fs"
  ];

#Flatpak
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

#Steam
programs.steam = {
  enable = true;

  package = pkgs.steam.override {
    extraArgs = "-system-composer";
  };

  gamescopeSession.enable = true;
};

}
