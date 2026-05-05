{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;

    theme = {
      name = "Kanagawa-BL";
      package = pkgs.kanagawa-gtk-theme;
    };

    iconTheme = {
      name = "Tela-circle";
      package = pkgs.tela-circle-icon-theme;
    };

    gtk3 = {
      bookmarks = [
        "file:///home/mny315/Documents"
        "file:///home/mny315/Downloads"
        "file:///home/mny315/Music"
        "file:///home/mny315/Pictures"
        "file:///home/mny315/Videos"
        "file:///etc/nixos"
      ];

      extraConfig = {
        gtk-recent-files-enabled = 0;
      };
    };

    gtk4 = {
      theme = null;

      extraConfig = {
        gtk-recent-files-enabled = 0;
      };
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = false;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Kanagawa-BL";
      icon-theme = "Tela-circle";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };
}
