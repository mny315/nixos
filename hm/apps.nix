{ config, pkgs, lib, ... }:

{

#Zsh
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

#Starship
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
        style = "bold yellow";
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
        style = "bold yellow";
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

#Mangohud
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

#mpv
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
      hide_timeout = 5000;
      bottom_hover = false;
      show_on_pause = true;
      keep_on_pause = true;
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

#Alacritty
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

      font = {
        size = 13.0;
        normal = {
          family = "Intel One Mono";
          style = "Regular";
        };
        bold = {
          family = "Intel One Mono";
          style = "Bold";
        };
        italic = {
          family = "Intel One Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Intel One Mono";
          style = "Bold Italic";
        };
      };

      colors = {
        primary = {
          foreground = "#C5C9C5";
          background = "#1D1C19";
        };

        cursor = {
          text = "#1D1C19";
          cursor = "#C4B28A";
        };

        vi_mode_cursor = {
          text = "#1D1C19";
          cursor = "#C4B28A";
        };

        selection = {
          text = "#C5C9C5";
          background = "#3A3427";
        };

        search = {
          matches = {
            foreground = "#1D1C19";
            background = "#C4B28A";
          };
          focused_match = {
            foreground = "#1D1C19";
            background = "#C4B28A";
          };
        };

        hints = {
          start = {
            foreground = "#1D1C19";
            background = "#C4B28A";
          };
          end = {
            foreground = "#1D1C19";
            background = "#625E5A";
          };
        };

        normal = {
          black = "#1D1C19";
          red = "#C4746E";
          green = "#8A9A7B";
          yellow = "#C4B28A";
          blue = "#8BA4B0";
          magenta = "#A292A3";
          cyan = "#8EA4A2";
          white = "#C5C9C5";
        };

        bright = {
          black = "#625E5A";
          red = "#E46876";
          green = "#87A987";
          yellow = "#E6C384";
          blue = "#7E9CD8";
          magenta = "#957FB8";
          cyan = "#7AA89F";
          white = "#DCD7BA";
        };
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

#hyprlock
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
        font_family = Lexend

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
        font_family = Lexend

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
        capslock_color = rgba(255, 180, 60, 0.90)

        fade_on_empty = true
        fade_timeout = 1200
        placeholder_text = Password
        hide_input = false
        rounding = -1
        fail_text = Wrong

        font_family = Lexend

        position = 0, -220
        halign = center
        valign = center
        zindex = 2

        shadow_passes = 2
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.25)
    }
  '';

#Hypridle
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
        timeout = 300
        on-timeout = ${pkgs.systemd}/bin/loginctl lock-session
    }

    listener {
        timeout = 330
        on-timeout = ${pkgs.writeShellScript "hypridle-niri-monitors-off" ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            exec ${pkgs.niri}/bin/niri msg action power-off-monitors
          fi
        ''}
        on-resume = ${pkgs.writeShellScript "hypridle-niri-monitors-on" ''
          if [ -n "''${NIRI_SOCKET:-}" ]; then
            exec ${pkgs.niri}/bin/niri msg action power-on-monitors
          fi
        ''}
    }
  '';

#nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.base16 = {
      enable = true;
      setUpBar = true;
      colorscheme = {
        base00 = "#1D1C19";
        base01 = "#23211E";
        base02 = "#2B2A27";
        base03 = "#625E5A";
        base04 = "#9E9B93";
        base05 = "#C5C9C5";
        base06 = "#DCD7BA";
        base07 = "#F2E5BC";
        base08 = "#C4746E";
        base09 = "#B98D7B";
        base0A = "#C4B28A";
        base0B = "#8A9A7B";
        base0C = "#8EA4A2";
        base0D = "#8BA4B0";
        base0E = "#A292A3";
        base0F = "#C4B28A";
      };
      settings = {
        telescope = true;
        telescope_borders = true;
        cmp = true;
        notify = true;
        indentblankline = true;
      };
    };

    opts = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      termguicolors = true;
      confirm = true;

      guifont = "Intel One Mono:h14";
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
      telescope.enable = true;
      treesitter.enable = true;

      web-devicons.enable = true;
      ui-select.enable = true;

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
      if vim.g.neovide then
        vim.o.guifont = "Intel One Mono:h14"
      end

      vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
      vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
      vim.g.lastplace_open_folds = 1
    '';
  };
}
