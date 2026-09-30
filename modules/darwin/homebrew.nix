{
  # Homebrew is only for apps Nix does not ship on Darwin.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
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
