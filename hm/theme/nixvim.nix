{ theme, ... }:

{
  # Nixvim
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
