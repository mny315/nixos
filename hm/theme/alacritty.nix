{ theme, ... }:

{
  # Alacritty
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
}
