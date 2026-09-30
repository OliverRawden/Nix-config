# Nix daemon. Root runs the rebuilds; this user is trusted so a
# user shell can use the daemon's extra features.
{ inputs, username, ... }:
{
  nixpkgs.config.allowUnfree = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # The Nix and nix-darwin modules already trust root. This list is
  # concatenated with that default.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ];
  };

  # --- Garbage collection ---
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.optimise.automatic = true;
}
