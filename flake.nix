{
  description = "flake of dank";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nvim-flake = {
      url = "github:dankuri/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nvim-flake,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    danknvim = nvim-flake.packages.${system}.default;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga401
        ];
      };
    };
    homeConfigurations = {
      dankuri = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit danknvim;};
        modules = [./home.nix];
      };
    };
  };
}
