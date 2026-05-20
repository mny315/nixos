{ pkgs, ... }:

let
  papirusIcons = pkgs.papirus-icon-theme.override {
    color = "black";
  };

  kanagawaCss = ''
@define-color kg_bg #1D1C19;
@define-color kg_bg_alt #23211E;
@define-color kg_bg_soft #2B2A27;
@define-color kg_bg_hover #34322E;
@define-color kg_border #625E5A;
@define-color kg_fg #C5C9C5;
@define-color kg_fg_dim #9E9B93;
@define-color kg_accent #C4B28A;
@define-color kg_accent_bg #3A3427;
@define-color kg_accent_bg_hover #4A3F2A;

    window,
    window.background,
    .background,
    dialog,
    messagedialog,
    assistant,
    .csd,
    popover,
    popover.background,
    menu,
    .menu,
    .context-menu,
    paned,
    notebook,
    stack,
    viewport,
    scrolledwindow,
    textview,
    textview text,
    treeview,
    treeview.view,
    iconview,
    list,
    listview,
    gridview,
    columnview,
    flowbox,
    .view,
    .standard-view,
    .standard-view .view {
      background-color: @kg_bg;
      background-image: none;
      color: @kg_fg;
    }

    headerbar,
    .titlebar,
    toolbar,
    menubar,
    statusbar,
    actionbar,
    searchbar,
    revealer,
    placessidebar,
    placessidebar viewport,
    placessidebar list,
    placessidebar row,
    sidebar,
    .sidebar,
    .sidebar list,
    .sidebar row,
    .sidebar .view,
    .path-bar {
      background-color: @kg_bg_alt;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_border;
    }

    button {
      background-image: none;
      color: @kg_fg;
      border-color: alpha(@kg_border, 0.35);
      border-radius: 6px;
      text-shadow: none;
      box-shadow: none;
    }

    entry,
    spinbutton,
    combobox,
    combobox box,
    dropdown,
    dropdown button,
    stackswitcher button,
    tab,
    switch,
    scale,
    scrollbar,
    scrollbar slider {
      background-color: @kg_bg_soft;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_border;
      border-radius: 6px;
      text-shadow: none;
      box-shadow: none;
    }

    progressbar,
    progressbar trough,
    levelbar,
    levelbar trough {
      background-color: @kg_bg_soft;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_border;
    }

    progressbar progress,
    levelbar block.filled {
      background-color: @kg_accent_bg_hover;
      background-image: none;
      border-color: @kg_accent;
    }

    button:hover,
    button:focus,
    entry:focus,
    spinbutton:focus,
    combobox:hover,
    dropdown button:hover,
    stackswitcher button:hover,
    tab:hover,
    row:hover,
    list row:hover,
    listview row:hover,
    gridview child:hover,
    columnview row:hover,
    flowbox child:hover,
    placessidebar row:hover,
    sidebar row:hover,
    .sidebar row:hover,
    treeview:hover,
    treeview.view:hover,
    iconview:hover,
    .view:hover,
    .standard-view .view:hover {
      background-color: @kg_bg_hover;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_accent;
    }

    button:checked,
    button:active,
    switch:checked,
    check:checked,
    radio:checked,
    row:selected,
    row:selected:hover,
    list row:selected,
    list row:selected:hover,
    listview row:selected,
    listview row:selected:hover,
    gridview child:selected,
    gridview child:selected:hover,
    columnview row:selected,
    columnview row:selected:hover,
    flowbox child:selected,
    flowbox child:selected:hover,
    placessidebar row:selected,
    placessidebar row:selected:hover,
    placessidebar row:selected:focus,
    sidebar row:selected,
    sidebar row:selected:hover,
    .sidebar row:selected,
    .sidebar row:selected:hover,
    treeview:selected,
    treeview:selected:focus,
    treeview.view:selected,
    treeview.view:selected:focus,
    iconview:selected,
    iconview:selected:focus,
    .view:selected,
    .view:selected:focus,
    .standard-view .view:selected,
    .standard-view .view:selected:focus {
      background-color: @kg_accent_bg;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_accent;
    }

    button:checked:hover,
    button:active:hover,
    row:selected:hover,
    list row:selected:hover,
    listview row:selected:hover,
    gridview child:selected:hover,
    columnview row:selected:hover,
    flowbox child:selected:hover,
    placessidebar row:selected:hover,
    sidebar row:selected:hover,
    .sidebar row:selected:hover,
    treeview:selected:hover,
    treeview.view:selected:hover,
    iconview:selected:hover,
    .view:selected:hover,
    .standard-view .view:selected:hover {
      background-color: @kg_accent_bg_hover;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_accent;
    }

    label,
    cellview,
    treeview header button label,
    placessidebar row label,
    sidebar row label,
    .sidebar row label,
    text,
    .title {
      color: @kg_fg;
    }

    label:disabled,
    button:disabled,
    entry:disabled,
    spinbutton:disabled,
    combobox:disabled,
    row:disabled,
    .dim-label {
      color: @kg_fg_dim;
    }

    separator,
    frame,
    border,
    treeview header button,
    scrolledwindow,
    notebook > header,
    headerbar,
    toolbar,
    actionbar,
    statusbar {
      border-color: @kg_border;
    }

    tooltip,
    tooltip.background {
      background-color: @kg_bg_soft;
      background-image: none;
      color: @kg_fg;
      border-color: @kg_border;
    }

    tooltip label {
      color: @kg_fg;
    }
  '';
in
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
      name = "Papirus-Dark";
      package = papirusIcons;
    };

    gtk3 = {
      iconTheme = {
        name = "Papirus-Dark";
        package = papirusIcons;
      };

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

      extraCss = kanagawaCss;
    };

    gtk4 = {
      iconTheme = {
        name = "Papirus-Dark";
        package = papirusIcons;
      };

      theme = null;

      extraConfig = {
        gtk-recent-files-enabled = 0;
      };

      extraCss = kanagawaCss;
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
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };
}
