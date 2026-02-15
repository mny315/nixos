{ inputs, pkgs, ... }:

{
  imports = [ 
    inputs.silentSDDM.nixosModules.default 
  ];

  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };
}
