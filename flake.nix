{
  description = "Rawden's nix-darwin configuration";

  inputs = {
    # Darwin nixpkgs only. home-manager follows it; useGlobalPkgs makes the
    # Mac use this set for user packages too.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # Account name. The same value is passed into the system modules and
    # home-manager. uid 501 in modules/user.nix must match this user.
    username = "rawden";
  in {
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs username; };
      modules = [
        ./modules
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.users.${username} = import ./modules/home;
        }
      ];
    };
  };
}
