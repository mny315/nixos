{ config, ... }:

{
  # Dotfiles
  xdg.configFile = builtins.mapAttrs
    (name: _: {
      source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/hm/dotfiles/${name}";
    })
    (builtins.readDir ./dotfiles);
}
