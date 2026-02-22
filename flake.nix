{
  description = "Alex's PC Configuration";

  inputs = {
    nixpkgs.url = "github:alexstaeding/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    algotex = {
      url = "github:alexstaeding/AlgoTeX/fix/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    algotex,
    plasma-manager,
    nixCats,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import nixpkgs {
      inherit system;
      overlays = [ (final: previous: { algotex = algotex.packages.${system}.default; }) ];
      config = { allowUnfree = true; };
    });
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      desktopuliana = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.uliana.imports = [
              ./home-manager/home.nix
              ./home-manager/module/vim
              ./home-manager/extra-linux.nix
              ./home-manager/nano-module.nix
            ];
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            home-manager.extraSpecialArgs = {
              inherit inputs outputs nixCats;
              pkgs = self.packages."x86_64-linux";
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      macbookuliana = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs outputs self; };
        modules = [
          ./nix-darwin/configuration.nix
          home-manager.darwinModules.home-manager {
            home-manager.users.uliana.imports = [
              ./home-manager/home.nix
              ./home-manager/module/vim
              ./home-manager/extra-macos.nix
              ./home-manager/nano-module.nix
            ];
            home-manager.extraSpecialArgs = {
              inherit inputs outputs;
              pkgs = self.packages."aarch64-darwin";
            };
          }
        ];
      };
    };
  };
}
