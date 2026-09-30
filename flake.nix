{
  description = "Rawden's Nix configuration for nix-darwin and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    # release-26.05 tracks nixos nixpkgs. Each host still uses its own
    # package set (nixpkgs-darwin on the Mac) because useGlobalPkgs is set.
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-darwin, nix-darwin, home-manager, ... }:
  let
    username = "rawden";

    mkHomeManager = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-bak";
      home-manager.extraSpecialArgs = { inherit inputs username; };
      home-manager.users.${username} = import ./modules/shared/home;
    };
  in {
    # MacBook Pro (Apple Silicon)
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs username; };
      modules = [
        ./hosts/darwin/MacBook-Pro
        home-manager.darwinModules.home-manager
        mkHomeManager
      ];
    };

    # Custom PC — Intel i5 + RX 7800 XT
    nixosConfigurations."pc" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs username; };
      modules = [
        ./hosts/nixos/pc
        home-manager.nixosModules.home-manager
        mkHomeManager
      ];
    };
  };
}
