{ config, pkgs, ... }:

{
  # Local binaries
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Zsh
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };

    syntaxHighlighting.enable = true;

    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  # MangoHud
  programs.mangohud = {
    enable = true;

    settings = {
      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;

      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      pci_dev = "0000:01:00.0";

      ram = true;
      vram = true;

      fps_limit = "60,90,240";
      toggle_fps_limit = "Alt_R";
      toggle_hud = "Control_R";

      position = "top-left";
      background_alpha = "0.5";
      font_size = 23;
      no_display = true;
    };
  };

  # MPV
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      mpris
      modernx-zydezu
    ];

    config = {
      vo = "gpu";
      gpu-api = "opengl";
      hwdec = "vaapi";
      profile = "fast";
      vd-lavc-threads = 4;
      dither-depth = "no";
      cache = "no";
      osc = false;
      border = false;
      video-unscaled = "no";
      keepaspect-window = "no";
      force-window = true;
      save-position-on-quit = true;
      osd-duration = 5000;
      osd-on-seek = "no";
    };

    scriptOpts.modernx = {
      osc_keep_with_cursor = true;
      hide_timeout = 1500;
      bottom_hover = true;
      show_on_pause = true;
      keep_on_pause = false;

      window_top_bar = "no";
      window_title = false;
      window_controls = false;
      show_windowed = true;
      show_fullscreen = true;
      ontop_button = false;
      osc_on_seek = false;
    };

    bindings = {
      "Ctrl+w" = "quit-watch-later";
      "Ctrl+q" = "quit-watch-later";
    };

    profiles = {
      Idle = {
        profile-cond = "p[\"idle-active\"]";
        profile-restore = "copy-equal";
        keepaspect = "no";
      };
    };
  };

  # Alacritty
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        opacity = 1.0;
        padding = {
          x = 12;
          y = 12;
        };
        decorations_theme_variant = "Dark";
      };

      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;

      keyboard.bindings = [
        {
          key = "C";
          mods = "Control";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control";
          action = "Paste";
        }
        {
          key = "С";
          mods = "Control";
          action = "Copy";
        }
        {
          key = "М";
          mods = "Control";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          chars = "\\u0003";
        }
        {
          key = "С";
          mods = "Control|Shift";
          chars = "\\u0003";
        }
        {
          key = "Insert";
          mods = "Control";
          action = "Copy";
        }
        {
          key = "Insert";
          mods = "Shift";
          action = "Paste";
        }
        {
          key = "=";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "-";
          mods = "Control";
          action = "DecreaseFontSize";
        }
        {
          key = "0";
          mods = "Control";
          action = "ResetFontSize";
        }
      ];
    };
  };

  # Hypridle
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = ${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock
        before_sleep_cmd = ${pkgs.systemd}/bin/loginctl lock-session
        after_sleep_cmd = ${pkgs.writeShellScript "hypridle-niri-monitors-on" ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            exec ${pkgs.niri}/bin/niri msg action power-on-monitors
          fi
        ''}
    }

    listener {
        timeout = 1000
        on-timeout = ${pkgs.systemd}/bin/loginctl lock-session
    }

    listener {
        timeout = 1030
        on-timeout = ${pkgs.writeShellScript "hypridle-niri-monitors-off" ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            exec ${pkgs.niri}/bin/niri msg action power-off-monitors
          fi
        ''}
    }
  '';

  # Nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      termguicolors = true;
      confirm = true;

      guifont = "IBM Plex Mono:h14";
    };

    keymaps = [
      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>write<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "i";
        key = "<C-s>";
        action = "<Esc><cmd>write<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<C-s>";
        action = "<Esc><cmd>write<CR>";
        options = {
          silent = true;
        };
      }
    ];

    plugins = {
      lualine.enable = true;
      telescope = {
        enable = true;
        extensions.ui-select.enable = true;
      };
      treesitter.enable = true;

      web-devicons.enable = true;

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope = {
            enabled = true;
            show_start = true;
          };
        };
      };

      nui.enable = true;
      notify.enable = true;

      noice = {
        enable = true;
        settings = {
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = true;
          };

          notify = {
            enabled = true;
          };
        };
      };

      dressing = {
        enable = true;
        settings.select.backend = [ "telescope" "nui" "builtin" ];
      };

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-lastplace
    ];

    extraConfigLua = ''
      vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
      vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
      vim.g.lastplace_open_folds = 1
    '';
  };
}
