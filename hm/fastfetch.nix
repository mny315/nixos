{ ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        source = "nixos_small";
        padding = {
          right = 3;
          top = 1;
        };
      };

      display = {
        separator = "  ";
        brightColor = false;

        color = {
          keys = "blue";
          title = "blue";
        };

        key = {
          width = 17;
        };
      };

      modules = [
        {
          type = "title";
          format = "{user-name-colored}@{host-name-colored}";
        }
        {
          type = "custom";
          format = "{#blue}╭────────────── 󰍹  System ──────────────{#}";
        }
        {
          type = "os";
          key = "│ {icon}  OS";
        }
        {
          type = "host";
          key = "│ {icon}  Host";
        }
        {
          type = "kernel";
          key = "│ {icon}  Kernel";
        }
        {
          type = "packages";
          key = "│ {icon}  Packages";
        }
        {
          type = "uptime";
          key = "│ {icon}  Uptime";
        }
        {
          type = "disk";
          key = "│ {icon}  System Age";
          keyIcon = "󰔟";
          folders = "/";
          format = "{create-time:10}  •  {days} days";
        }
        {
          type = "custom";
          format = "{#blue}╰──────────────────────────────────────{#}";
        }
        "break"
        {
          type = "custom";
          format = "{#cyan}╭───────────── 󰋊  Hardware ─────────────{#}";
        }
        {
          type = "cpu";
          key = "│ {icon}  CPU";
          showPeCoreCount = true;
        }
        {
          type = "gpu";
          key = "│ {icon}  GPU";
        }
        {
          type = "memory";
          key = "│ {icon}  Memory";
        }
        {
          type = "disk";
          key = "│ {icon}  Disk";
          folders = "/";
          format = "{size-used} / {size-total} ({size-percentage})";
        }
        {
          type = "display";
          key = "│ {icon}  Display";
          compactType = "original-with-refresh-rate";
        }
        {
          type = "custom";
          format = "{#cyan}╰──────────────────────────────────────{#}";
        }
        "break"
        {
          type = "custom";
          format = "{#magenta}╭──────────────   Desktop ─────────────{#}";
        }
        {
          type = "wm";
          key = "│ {icon}  WM";
        }
        {
          type = "shell";
          key = "│ {icon}  Shell";
        }
        {
          type = "terminal";
          key = "│ {icon}  Terminal";
        }
        {
          type = "terminalfont";
          key = "│ {icon}  Font";
        }
        {
          type = "locale";
          key = "│ {icon}  Locale";
        }
        {
          type = "custom";
          format = "{#magenta}╰──────────────────────────────────────{#}";
        }
        "break"
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };
}
