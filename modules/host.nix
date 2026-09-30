# Hostname, clock, and housekeeping.
# If you rename the machine, change localHostName here and the
# darwinConfigurations name in flake.nix together.
{ ... }:
{
  # --- Identity ---
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.localHostName = "MacBook-Pro";
  # Leave this at 6. nix-darwin uses it for migration defaults, not the macOS version.
  system.stateVersion = 6;
  time.timeZone = "Europe/London";

  # Headless aarch64-linux builder for Linux packages built on this Mac.
  nix.linux-builder.enable = true;

  # --- Garbage collection ---
  # Sunday 03:00. How much to delete is set in nix.nix.
  nix.gc.interval = {
    Weekday = 0;
    Hour = 3;
    Minute = 0;
  };
}
