{
  description = "NixOS Configuration Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/main";
    };

    niri.url = "github:sodiboo/niri-flake";

    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    obsidian-shell = {
      url = "github:mny315/Obsidian-shell";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, nixvim, niri, ... } @ inputs:
    let
      specialArgs = { inherit inputs self; };

      commonModules = [
        niri.nixosModules.niri
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager

        ({ pkgs, ... }: {
          programs.niri = {
            enable = true;
            package = niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
          };

          environment.sessionVariables.NIXOS_OZONE_WL = "1";

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;

            users.mny315 = {
              imports = [
                ./hm/home.nix
                nixvim.homeModules.nixvim
                ({ ... }: {
                  programs.nixvim.nixpkgs.source = inputs.nixvim.inputs.nixpkgs;
                })
                inputs.ags.homeManagerModules.default
              ];
            };
          };
        })
      ];
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/laptop/configuration.nix
          ] ++ commonModules;
        };

        desktop = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/desktop/configuration.nix
          ] ++ commonModules;
        };
      };
    };
}
