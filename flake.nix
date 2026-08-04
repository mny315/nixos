{
  description = "NixOS Configuration Home Manager";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim
    nixvim = {
      url = "github:nix-community/nixvim/main";
    };

    # Obsidian Bar
    obsidian-bar = {
      url = "github:mny315/Obsidian-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HyperX Cloud III S audio switch
    hyperx-cloud-3-switchd = {
      url = "github:mny315/Hyperx-cloud-3-switchd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # PortProtonQt
    portprotonqt-src = {
      url = "github:Boria138/PortProtonQt/v1.3.1";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... } @ inputs: {
    # Hosts
    nixosConfigurations = builtins.mapAttrs (
      _: hostModule:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        # Shared modules
        modules = [
          hostModule
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            # Obsidian Bar
            environment.systemPackages = [
              inputs.obsidian-bar.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            # Niri
            programs.niri = {
              enable = true;
              useNautilus = false;
            };

            # Home Manager
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.theme = import ./hm/theme/palette.nix;
              users.mny315.imports = [
                ./hm/home.nix
                nixvim.homeModules.nixvim
              ];
            };
          })
        ];
      }
    ) {
      laptop = ./hosts/laptop/configuration.nix;
      desktop = ./hosts/desktop/configuration.nix;
    };
  };
}
