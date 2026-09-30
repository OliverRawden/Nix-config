# System modules for this Mac.
# Add a new file to this list to include it in the rebuild.
{
  imports = [
    # --- Machine ---
    ./host.nix
    ./nix.nix
    ./user.nix

    # --- Software ---
    ./packages.nix
    ./programming.nix
    ./shell.nix
    ./fonts.nix
    ./homebrew.nix

    # --- macOS ---
    ./defaults.nix
    ./control-center.nix
    ./windows.nix
    ./jdk.nix
    ./telemetry.nix
  ];
}
