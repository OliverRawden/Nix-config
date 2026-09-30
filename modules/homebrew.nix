# Apps Nix does not ship on aarch64-darwin.
# Add a cask name here. cleanup = "none" leaves anything installed
# by hand alone, including formulae.
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    # --- Casks ---
    casks = [
      "zen"
      "ghostty"
      "nheko"
      "raycast"
      "karabiner-elements"
      # Missing or Linux-only in nixpkgs on aarch64-darwin.
      "autodesk-fusion"
      "android-studio"
      "freecad"
    ];
  };
}
