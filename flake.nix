{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Добавляем виновника торжества
    nix-flatpak.url = "github:gmodena/nix-flatpak"; 

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... } @ inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ 
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/laptop/configuration.nix 
          
          nix-flatpak.nixosModules.nix-flatpak

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mny315 = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs self; };
          }
        ];
      };
    };
  };
}
