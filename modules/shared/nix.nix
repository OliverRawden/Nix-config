{ inputs, username, ... }:
{
  # --- Nix daemon ---
  nixpkgs.config.allowUnfree = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The Nix and nix-darwin modules already trust root, and this
  # list is concatenated with that default. Root runs the rebuilds.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ];
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.optimise.automatic = true;
}
