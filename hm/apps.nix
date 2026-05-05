{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # MangoHud
  programs.mangohud = {
    enable = true;

    settings = {
      # CPU
      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;

      # GPU
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      pci_dev = "0000:01:00.0";

      # RAM
      ram = true;
      vram = true;
      
      # FPS & controls
      fps_limit = "60,90,240";
      toggle_fps_limit = "Alt_R";
      toggle_hud = "Control_R" ;

      # Appearance
      position = "top-left";
      background_alpha = "0.5";
      font_size = 23;
      no_display = true;
    };
  };

  # mpv
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
  # WezTerm
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local act = wezterm.action
      local config = wezterm.config_builder()

      config.term = "wezterm"
      config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "JetBrains Mono" })
      config.font_size = 13.0
      config.enable_tab_bar = false
      config.window_padding = {
        left = 12,
        right = 12,
        top = 12,
        bottom = 12,
      }
      config.window_close_confirmation = "NeverPrompt"
      config.enable_wayland = true
      config.front_end = "WebGpu"
      config.window_background_opacity = 0.95
      config.text_background_opacity = 1.0
      config.use_fancy_tab_bar = false
      config.hide_tab_bar_if_only_one_tab = true

      config.color_schemes = {
        ["FluentDark"] = {
          foreground = "#d7dee9",
          background = "#202124",
          cursor_bg = "#60cdff",
          cursor_fg = "#202124",
          cursor_border = "#60cdff",
          selection_fg = "#eaf2fb",
          selection_bg = "#2f4457",
          scrollbar_thumb = "#333842",
          split = "#333842",
          ansi = {
            "#202124",
            "#ff7b72",
            "#7ee787",
            "#e6d06c",
            "#60cdff",
            "#b392f0",
            "#56d4dd",
            "#d7dee9",
          },
          brights = {
            "#5f6a79",
            "#ff9b95",
            "#9df0a6",
            "#f0dc84",
            "#8bdeff",
            "#cab0ff",
            "#7be3ea",
            "#f3f7fb",
          },
        },
      }
      config.color_scheme = "FluentDark"

      config.keys = {
        { key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
        { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
        { key = "C", mods = "CTRL|SHIFT", action = act.SendKey { key = "c", mods = "CTRL" } },
      }

      return config
    '';
  };


  # Hyprlock
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
        path = /etc/nixos/home-manager/dotfiles/images/avatar/avatar.jpg
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

  # NixVim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.base16 = {
      enable = true;
      setUpBar = true;
      colorscheme = {
        base00 = "#202124";
        base01 = "#2a2d33";
        base02 = "#333842";
        base03 = "#5f6a79";
        base04 = "#7c8798";
        base05 = "#d7dee9";
        base06 = "#e5eef8";
        base07 = "#f3f7fb";
        base08 = "#ff7b72";
        base09 = "#ffb86b";
        base0A = "#e6d06c";
        base0B = "#7ee787";
        base0C = "#56d4dd";
        base0D = "#60cdff";
        base0E = "#b392f0";
        base0F = "#c17e70";
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
        vim.o.guifont = "JetBrainsMono Nerd Font:h14"
      end

      vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
      vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
      vim.g.lastplace_open_folds = 1
    '';
  };
}
