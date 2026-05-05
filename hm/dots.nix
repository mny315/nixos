{ config, ... }: 
let
  dotfilesPath = "/etc/nixos/hm/dotfiles";
in
{
  xdg.configFile = builtins.mapAttrs 
    (name: _: { 
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${name}"; 
    }) 
    (builtins.readDir ./dotfiles);
}
