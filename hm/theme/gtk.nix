{ pkgs, theme, ... }:

let
  papirusIcons = pkgs.papirus-icon-theme.override {
    color = "grey";
  };

  gtkOverridesCss = ''
    @define-color nt_bg ${theme.bg};
    @define-color nt_bg_alt ${theme.bgAlt};
    @define-color nt_bg_soft ${theme.bgSoft};
    @define-color nt_bg_hover ${theme.bgHover};
    @define-color nt_selected ${theme.selected};
    @define-color nt_selected_hover ${theme.selectedHover};
    @define-color nt_border ${theme.border};
    @define-color nt_fg ${theme.fg};
    @define-color nt_fg_dim ${theme.fgDim};
    @define-color nt_fg_muted ${theme.fgMuted};
    @define-color nt_red ${theme.red};

    @define-color theme_bg_color @nt_bg;
    @define-color theme_fg_color @nt_fg;
    @define-color theme_base_color @nt_bg;
    @define-color theme_text_color @nt_fg;
    @define-color theme_selected_bg_color @nt_selected;
    @define-color theme_selected_fg_color @nt_fg;
    @define-color theme_unfocused_bg_color @nt_bg;
    @define-color theme_unfocused_fg_color @nt_fg_dim;
    @define-color theme_unfocused_base_color @nt_bg;
    @define-color theme_unfocused_text_color @nt_fg_dim;
    @define-color theme_unfocused_selected_bg_color @nt_bg_hover;
    @define-color theme_unfocused_selected_fg_color @nt_fg;
    @define-color insensitive_bg_color @nt_bg_soft;
    @define-color insensitive_fg_color @nt_fg_muted;
    @define-color insensitive_base_color @nt_bg_soft;
    @define-color borders @nt_border;
    @define-color unfocused_borders @nt_border;
    @define-color warning_color @nt_fg;
    @define-color error_color @nt_red;
    @define-color success_color ${theme.green};

    @define-color window_bg_color @nt_bg;
    @define-color window_fg_color @nt_fg;
    @define-color view_bg_color @nt_bg;
    @define-color view_fg_color @nt_fg;
    @define-color headerbar_bg_color @nt_bg_alt;
    @define-color headerbar_fg_color @nt_fg;
    @define-color headerbar_border_color @nt_border;
    @define-color headerbar_backdrop_color @nt_bg;
    @define-color popover_bg_color @nt_bg_soft;
    @define-color popover_fg_color @nt_fg;
    @define-color card_bg_color @nt_bg_soft;
    @define-color card_fg_color @nt_fg;
    @define-color sidebar_bg_color @nt_bg_alt;
    @define-color sidebar_fg_color @nt_fg;
    @define-color sidebar_backdrop_color @nt_bg;
    @define-color sidebar_border_color @nt_border;
    @define-color accent_bg_color @nt_selected_hover;
    @define-color accent_fg_color @nt_fg;
    @define-color accent_color @nt_fg_dim;
    @define-color destructive_bg_color @nt_red;
    @define-color destructive_fg_color @nt_fg;

    * {
      text-shadow: none;
      box-shadow: none;
    }

    window,
    window.background,
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
    .standard-view {
      background-color: @nt_bg;
      background-image: none;
      color: @nt_fg;
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
      background-color: @nt_bg_alt;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_border;
    }

    button,
    dropdown button,
    stackswitcher button,
    treeview header button {
      background-color: alpha(@nt_bg_soft, 0.72);
      background-image: none;
      color: @nt_fg;
      border: 1px solid alpha(@nt_border, 0.42);
      border-radius: 8px;
      padding: 4px 10px;
      min-height: 24px;
      min-width: 0;
      text-shadow: none;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
      outline-offset: 0;
      outline-color: transparent;
    }

    entry,
    spinbutton,
    combobox,
    combobox box,
    dropdown,
    tab,
    switch,
    scale,
    scrollbar,
    scrollbar slider {
      background-color: @nt_bg_soft;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_border;
      border-radius: 10px;
      text-shadow: none;
      box-shadow: none;
    }

    progressbar,
    progressbar trough,
    levelbar,
    levelbar trough {
      background-color: @nt_bg_soft;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_border;
    }

    progressbar progress,
    levelbar block.filled {
      background-color: @nt_selected_hover;
      background-image: none;
      border-color: @nt_fg_dim;
    }

    button:hover,
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
    treeview.view:hover {
      background-color: @nt_bg_hover;
      background-image: none;
      color: @nt_fg;
      border-color: alpha(@nt_fg_dim, 0.55);
    }

    button:focus,
    button.default,
    button.suggested-action,
    dropdown button:focus,
    stackswitcher button:focus {
      background-color: alpha(@nt_bg_soft, 0.72);
      background-image: none;
      color: @nt_fg;
      border: 1px solid alpha(@nt_border, 0.42);
      border-radius: 8px;
      padding: 4px 10px;
      min-height: 24px;
      min-width: 0;
      outline-style: none;
      outline-width: 0;
      outline-offset: 0;
      outline-color: transparent;
      box-shadow: none;
    }

    button:focus:hover,
    button.default:hover,
    button.suggested-action:hover,
    dropdown button:focus:hover,
    stackswitcher button:focus:hover {
      background-color: @nt_bg_hover;
      background-image: none;
      color: @nt_fg;
      border: 1px solid alpha(@nt_fg_dim, 0.55);
      box-shadow: none;
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
    treeview.view:selected:focus {
      background-color: @nt_selected;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_fg_dim;
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
    treeview.view:selected:hover {
      background-color: @nt_selected_hover;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_fg;
    }

    label,
    cellview,
    treeview header button label,
    placessidebar row label,
    sidebar row label,
    .sidebar row label,
    text,
    .title {
      color: @nt_fg;
    }

    label:disabled,
    button:disabled,
    entry:disabled,
    spinbutton:disabled,
    combobox:disabled,
    row:disabled,
    .dim-label {
      color: @nt_fg_dim;
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
      border-color: @nt_border;
    }

    tooltip,
    tooltip.background {
      background-color: @nt_bg_soft;
      background-image: none;
      color: @nt_fg;
      border-color: @nt_border;
    }

    tooltip label {
      color: @nt_fg;
    }

    /* Popup/context menus. The popup window must stay transparent, otherwise rounded menu corners are hidden by a rectangular GTK surface. */
    window.popup,
    window.popup.background,
    window.background.popup {
      background-color: transparent;
      background-image: none;
      border-radius: 16px;
      box-shadow: none;
    }

    window.popup > menu,
    window.popup menu,
    menu,
    .menu,
    .context-menu {
      background-color: alpha(@nt_bg_alt, 0.74);
      background-image: none;
      color: @nt_fg;
      border: 1px solid alpha(@nt_border, 0.65);
      border-radius: 16px;
      padding: 7px;
      box-shadow: none;
    }

    menu menuitem,
    .menu menuitem,
    .context-menu menuitem {
      background-color: transparent;
      background-image: none;
      color: @nt_fg;
      border-radius: 11px;
      padding: 6px 10px;
    }

    menu menuitem:hover,
    menu menuitem:focus,
    .menu menuitem:hover,
    .menu menuitem:focus,
    .context-menu menuitem:hover,
    .context-menu menuitem:focus {
      background-color: alpha(@nt_selected_hover, 0.72);
      background-image: none;
      color: @nt_fg;
    }

    menu menuitem:disabled,
    .menu menuitem:disabled,
    .context-menu menuitem:disabled,
    menu menuitem accelerator,
    .menu menuitem accelerator,
    .context-menu menuitem accelerator {
      color: @nt_fg_dim;
    }

    menu separator,
    .menu separator,
    .context-menu separator {
      background-color: alpha(@nt_border, 0.35);
      min-height: 1px;
      margin: 4px 6px;
    }

    /* Thunar: keep file-pane styling scoped. Broad `.view` rules leak into the
       sidebar/tree and make selected icons look huge or randomly shaped. */
    .thunar .standard-view,
    .thunar .standard-view viewport,
    .thunar .standard-view scrolledwindow,
    .thunar .standard-view iconview.view,
    .thunar .standard-view treeview.view {
      background-color: @nt_bg;
      background-image: none;
      color: @nt_fg;
    }

    .thunar .standard-view iconview.view {
      border-radius: 0;
      padding: 0;
      margin: 0;
    }

    .thunar .standard-view iconview.view:hover,
    .thunar .standard-view iconview.view:focus,
    .thunar .standard-view iconview.view:backdrop {
      background-color: @nt_bg;
      background-image: none;
      color: @nt_fg;
    }

    .thunar .standard-view iconview.view:selected,
    .thunar .standard-view iconview.view:selected:focus,
    .thunar .standard-view iconview.view:selected:hover,
    .thunar .standard-view iconview.view:selected:backdrop {
      background-color: alpha(@nt_selected, 0.82);
      background-image: none;
      color: @nt_fg;
      border-color: alpha(@nt_fg_dim, 0.60);
      border-radius: 6px;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
    }

    .thunar .standard-view treeview.view:selected,
    .thunar .standard-view treeview.view:selected:focus,
    .thunar .standard-view treeview.view:selected:hover,
    .thunar .standard-view treeview.view:selected:backdrop {
      background-color: @nt_selected;
      background-image: none;
      color: @nt_fg;
      border-radius: 0;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
    }

    .thunar placessidebar row:selected,
    .thunar placessidebar row:selected:hover,
    .thunar placessidebar row:selected:focus,
    .thunar .sidebar row:selected,
    .thunar .sidebar row:selected:hover,
    .thunar .sidebar row:selected:focus {
      background-color: @nt_selected;
      background-image: none;
      color: @nt_fg;
      border-radius: 8px;
    }

    /* Thunar drag-selection rectangle. GtkIconView exposes it as the `rubberband`
       subnode under `iconview.view`; keep this at the end so imported CSS loses. */
    .thunar .standard-view iconview.view rubberband,
    .thunar .standard-view iconview.view .rubberband,
    .thunar iconview.view rubberband,
    .thunar iconview.view .rubberband,
    iconview.view rubberband,
    iconview.view .rubberband {
      background-color: alpha(@nt_fg_dim, 0.035);
      background-image: none;
      border: 1px solid alpha(@nt_fg_dim, 0.50);
      border-radius: 0;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
    }


    /* Message dialogs: GtkButtonBox often expands response buttons across the
       whole bottom row. Keep the visible button box compact with margins, so an
       action area does not look like two giant slabs. */
    messagedialog buttonbox.dialog-action-area,
    dialog buttonbox.dialog-action-area,
    messagedialog .dialog-action-area,
    dialog .dialog-action-area {
      background-color: transparent;
      background-image: none;
      border-color: alpha(@nt_border, 0.30);
      padding: 4px 8px;
    }

    messagedialog buttonbox.dialog-action-area button,
    dialog buttonbox.dialog-action-area button,
    messagedialog .dialog-action-area button,
    dialog .dialog-action-area button {
      background-color: transparent;
      background-image: none;
      color: @nt_fg_dim;
      border: 1px solid alpha(@nt_border, 0.34);
      border-radius: 8px;
      padding: 4px 14px;
      margin: 5px 12px;
      min-width: 82px;
      min-height: 26px;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
      outline-offset: 0;
      outline-color: transparent;
    }

    messagedialog buttonbox.dialog-action-area button:hover,
    dialog buttonbox.dialog-action-area button:hover,
    messagedialog .dialog-action-area button:hover,
    dialog .dialog-action-area button:hover {
      background-color: alpha(@nt_bg_hover, 0.70);
      background-image: none;
      color: @nt_fg;
      border-color: alpha(@nt_fg_dim, 0.45);
      box-shadow: none;
    }

    messagedialog buttonbox.dialog-action-area button:focus,
    messagedialog buttonbox.dialog-action-area button.default,
    messagedialog buttonbox.dialog-action-area button.suggested-action,
    dialog buttonbox.dialog-action-area button:focus,
    dialog buttonbox.dialog-action-area button.default,
    dialog buttonbox.dialog-action-area button.suggested-action,
    messagedialog .dialog-action-area button:focus,
    messagedialog .dialog-action-area button.default,
    messagedialog .dialog-action-area button.suggested-action,
    dialog .dialog-action-area button:focus,
    dialog .dialog-action-area button.default,
    dialog .dialog-action-area button.suggested-action {
      background-color: transparent;
      background-image: none;
      color: @nt_fg_dim;
      border: 1px solid alpha(@nt_border, 0.34);
      border-radius: 8px;
      padding: 4px 14px;
      margin: 5px 12px;
      min-width: 82px;
      min-height: 26px;
      box-shadow: none;
      outline-style: none;
      outline-width: 0;
      outline-offset: 0;
      outline-color: transparent;
    }
  '';

  # GTK4/libadwaita: only override named colors. Generic widget selectors
  # can cover Loupe's image rendering widgets, so keep those GTK3-only.
  gtk4OverridesCss = ''
    @define-color nt_bg ${theme.bg};
    @define-color nt_bg_alt ${theme.bgAlt};
    @define-color nt_bg_soft ${theme.bgSoft};
    @define-color nt_bg_hover ${theme.bgHover};
    @define-color nt_selected ${theme.selected};
    @define-color nt_selected_hover ${theme.selectedHover};
    @define-color nt_border ${theme.border};
    @define-color nt_fg ${theme.fg};
    @define-color nt_fg_dim ${theme.fgDim};
    @define-color nt_fg_muted ${theme.fgMuted};
    @define-color nt_red ${theme.red};

    @define-color theme_bg_color @nt_bg;
    @define-color theme_fg_color @nt_fg;
    @define-color theme_base_color @nt_bg;
    @define-color theme_text_color @nt_fg;
    @define-color theme_selected_bg_color @nt_selected;
    @define-color theme_selected_fg_color @nt_fg;
    @define-color theme_unfocused_bg_color @nt_bg;
    @define-color theme_unfocused_fg_color @nt_fg_dim;
    @define-color theme_unfocused_base_color @nt_bg;
    @define-color theme_unfocused_text_color @nt_fg_dim;
    @define-color theme_unfocused_selected_bg_color @nt_bg_hover;
    @define-color theme_unfocused_selected_fg_color @nt_fg;
    @define-color insensitive_bg_color @nt_bg_soft;
    @define-color insensitive_fg_color @nt_fg_muted;
    @define-color insensitive_base_color @nt_bg_soft;
    @define-color borders @nt_border;
    @define-color unfocused_borders @nt_border;
    @define-color warning_color @nt_fg;
    @define-color error_color @nt_red;
    @define-color success_color ${theme.green};

    @define-color window_bg_color @nt_bg;
    @define-color window_fg_color @nt_fg;
    @define-color view_bg_color @nt_bg;
    @define-color view_fg_color @nt_fg;
    @define-color headerbar_bg_color @nt_bg_alt;
    @define-color headerbar_fg_color @nt_fg;
    @define-color headerbar_border_color @nt_border;
    @define-color headerbar_backdrop_color @nt_bg;
    @define-color popover_bg_color @nt_bg_soft;
    @define-color popover_fg_color @nt_fg;
    @define-color card_bg_color @nt_bg_soft;
    @define-color card_fg_color @nt_fg;
    @define-color sidebar_bg_color @nt_bg_alt;
    @define-color sidebar_fg_color @nt_fg;
    @define-color sidebar_backdrop_color @nt_bg;
    @define-color sidebar_border_color @nt_border;
    @define-color accent_bg_color @nt_selected_hover;
    @define-color accent_fg_color @nt_fg;
    @define-color accent_color @nt_fg_dim;
    @define-color destructive_bg_color @nt_red;
    @define-color destructive_fg_color @nt_fg;
  '';

  gtk3OverridesCss = ''
    ${gtkOverridesCss}

    button,
    dropdown button,
    stackswitcher button,
    treeview header button {
      -gtk-outline-radius: 8px;
      outline-style: none;
      outline-width: 0;
      outline-offset: 0;
      outline-color: transparent;
      box-shadow: none;
    }
  '';

  gtk3ThemeCss = ''
    @import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");

    ${gtk3OverridesCss}
  '';

  gtk4ThemeCss = ''
    @import url("resource:///org/gtk/libgtk/theme/Default/Default-dark.css");

    ${gtk4OverridesCss}
  '';
in
{
  # GTK renderer
  # GTK4 Vulkan renderer is still noisy in AGS/GJS on some setups.
  # Force the OpenGL renderer to avoid vkAcquireNextImageKHR spam.
  home.sessionVariables = {
    GSK_RENDERER = "opengl";
  };

  # GTK
  gtk = {
    enable = true;

    theme = {
      name = theme.name;
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
        gtk-application-prefer-dark-theme = 1;
        gtk-icon-theme-name = "Papirus-Dark";
        gtk-recent-files-enabled = 0;
        gtk-theme-name = theme.name;
      };

      extraCss = gtk3OverridesCss;
    };

    gtk4 = {
      iconTheme = {
        name = "Papirus-Dark";
        package = papirusIcons;
      };

      theme = null;

      extraConfig = {
        gtk-icon-theme-name = "Papirus-Dark";
        gtk-recent-files-enabled = 0;
      };

      extraCss = gtk4OverridesCss;
    };
  };

  # GTK theme files
  home.file = {
    ".themes/${theme.name}/index.theme".text = ''
      [Desktop Entry]
      Type=X-GNOME-Metatheme
      Name=${theme.name}
      Comment=Dark neutral theme with white text and neutral accent

      [X-GNOME-Metatheme]
      GtkTheme=${theme.name}
      IconTheme=Papirus-Dark
      CursorTheme=Bibata-Modern-Classic
    '';

    ".themes/${theme.name}/gtk-3.0/gtk.css".text = gtk3ThemeCss;
    ".themes/${theme.name}/gtk-4.0/gtk.css".text = gtk4ThemeCss;
  };

  # User directories
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = false;
  };

  # Cursor
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  # GNOME
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = theme.name;
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };
}
