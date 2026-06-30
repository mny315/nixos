{ pkgs, ... }:

let
  papirusIcons = pkgs.papirus-icon-theme.override {
    color = "grey";
  };

  theme = rec {
    name = "Obsidian-Neutral";

    bg = "#1D1C19";
    bgAlt = "#23211E";
    bgSoft = "#2B2A27";
    bgHover = "#3D3A35";
    selected = "#42464F";
    selectedHover = "#565B66";
    border = "#625E5A";

    fg = "#FFFFFF";
    fgDim = "#C9CDD3";
    fgMuted = "#9E9B93";

    black = bg;
    blackBright = border;
    red = "#C4746E";
    redBright = "#E46876";
    green = "#8A9A7B";
    greenBright = "#87A987";
    blue = "#8BA4B0";
    blueBright = "#7E9CD8";
    magenta = "#A292A3";
    magentaBright = "#957FB8";
    cyan = "#8EA4A2";
    cyanBright = "#7AA89F";
    white = "#C5C9C5";
    whiteBright = fg;
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

    ${gtkOverridesCss}
  '';
in
{
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # GTK4 Vulkan renderer is still noisy in AGS/GJS on some setups.
  # Force the OpenGL renderer to avoid vkAcquireNextImageKHR spam.
  home.sessionVariables = {
    GSK_RENDERER = "opengl";
  };

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
        gtk-application-prefer-dark-theme = 1;
        gtk-icon-theme-name = "Papirus-Dark";
        gtk-recent-files-enabled = 0;
        gtk-theme-name = theme.name;
      };

      extraCss = gtkOverridesCss;
    };
  };

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

  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    setSessionVariables = false;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = theme.name;
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };

  # Starship theme
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      format = "$username$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      right_format = "$time";

      username = {
        show_always = true;
        style_user = "bold green";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bold white";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "bold cyan";
        truncation_length = 4;
        truncate_to_repo = false;
        format = "[$path]($style) ";
      };

      git_branch = {
        symbol = "git:";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold red";
        format = "[$all_status$ahead_behind]($style) ";
      };

      nix_shell = {
        symbol = "nix ";
        style = "bold blue";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      cmd_duration = {
        min_time = 1000;
        style = "bold white";
        format = "took [$duration]($style) ";
      };

      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "bold white";
        format = "[$time]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };
    };
  };

  # Alacritty theme
  programs.alacritty.settings = {
    font = {
      size = 13.0;
      normal = {
        family = "IBM Plex Mono";
        style = "Regular";
      };
      bold = {
        family = "IBM Plex Mono";
        style = "Bold";
      };
      italic = {
        family = "IBM Plex Mono";
        style = "Italic";
      };
      bold_italic = {
        family = "IBM Plex Mono";
        style = "Bold Italic";
      };
    };

    colors = {
      primary = {
        foreground = theme.fg;
        background = theme.bg;
      };

      cursor = {
        text = theme.bg;
        cursor = theme.fg;
      };

      vi_mode_cursor = {
        text = theme.bg;
        cursor = theme.fg;
      };

      selection = {
        text = theme.fg;
        background = theme.selected;
      };

      search = {
        matches = {
          foreground = theme.bg;
          background = theme.fgDim;
        };
        focused_match = {
          foreground = theme.bg;
          background = theme.fg;
        };
      };

      hints = {
        start = {
          foreground = theme.bg;
          background = theme.fgDim;
        };
        end = {
          foreground = theme.bg;
          background = theme.border;
        };
      };

      normal = {
        black = theme.black;
        red = theme.red;
        green = theme.green;
        yellow = theme.fg;
        blue = theme.blue;
        magenta = theme.magenta;
        cyan = theme.cyan;
        white = theme.white;
      };

      bright = {
        black = theme.blackBright;
        red = theme.redBright;
        green = theme.greenBright;
        yellow = theme.fg;
        blue = theme.blueBright;
        magenta = theme.magentaBright;
        cyan = theme.cyanBright;
        white = theme.whiteBright;
      };
    };
  };

  # Hyprlock theme
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
        ignore_empty_input = true
        immediate_render = true
        text_trim = true
        fail_timeout = 1000
    }

    animations {
        enabled = true
    }

    background {
        monitor =
        path = screenshot
        color = rgba(12, 12, 12, 1.0)

        blur_passes = 3
        blur_size = 8
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.05
    }

    label {
        monitor =
        text = cmd[update:1000] ${pkgs.bash}/bin/bash -lc 'date "+%H:%M"'
        color = rgba(255, 255, 255, 0.96)
        font_size = 78
        font_family = IBM Plex Sans

        position = 0, 270
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 3
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.45)
    }

    label {
        monitor =
        text = cmd[update:60000] ${pkgs.bash}/bin/bash -lc 'date "+%A, %d %B"'
        color = rgba(255, 255, 255, 0.76)
        font_size = 22
        font_family = IBM Plex Sans

        position = 0, 210
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 2
        shadow_size = 6
        shadow_color = rgba(0, 0, 0, 0.35)
    }

    image {
        monitor =
        path = /etc/nixos/hm/dotfiles/images/avatar/avatar.jpg
        size = 162
        rounding = -1
        border_size = 2
        border_color = rgba(255, 255, 255, 0.18)

        position = 0, 40
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 3
        shadow_size = 10
        shadow_color = rgba(0, 0, 0, 0.35)
    }

    input-field {
        monitor =
        size = 330, 60
        outline_thickness = 1
        dots_size = 0.18
        dots_spacing = 0.30
        dots_center = true
        dots_rounding = -1
        dots_text_format = *

        outer_color = rgba(255, 255, 255, 0.18)
        inner_color = rgba(10, 10, 10, 0.42)
        font_color = rgba(255, 255, 255, 0.96)
        check_color = rgba(255, 255, 255, 0.28)
        fail_color = rgba(255, 90, 90, 0.90)
        capslock_color = rgba(255, 255, 255, 0.70)

        fade_on_empty = true
        fade_timeout = 1200
        placeholder_text = Password
        hide_input = false
        rounding = -1
        fail_text = Wrong

        font_family = IBM Plex Sans

        position = 0, -220
        halign = center
        valign = center
        zindex = 2

        shadow_passes = 2
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.25)
    }
  '';

  # Nixvim theme
  programs.nixvim.colorschemes.base16 = {
    enable = true;
    setUpBar = true;
    colorscheme = {
      base00 = theme.bg;
      base01 = theme.bgAlt;
      base02 = theme.bgSoft;
      base03 = theme.border;
      base04 = theme.fgMuted;
      base05 = theme.fg;
      base06 = "#F2F2F2";
      base07 = theme.fg;
      base08 = theme.red;
      base09 = theme.fgDim;
      base0A = theme.fg;
      base0B = theme.green;
      base0C = theme.cyan;
      base0D = theme.blue;
      base0E = theme.magenta;
      base0F = theme.fgDim;
    };
    settings = {
      telescope = true;
      telescope_borders = true;
      cmp = true;
      notify = true;
      indentblankline = true;
    };
  };
}
