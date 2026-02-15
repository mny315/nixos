{ config, ... }: {
xdg.configFile = builtins.mapAttrs 
  (name: _: { source = ./dotfiles + "/${name}"; }) 
  (builtins.readDir ./dotfiles);
  }
