{ ... }:
{
  imports = [
    ../../../modules/shared
    ../../../modules/darwin
  ];

  # --- Identity ---
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.localHostName = "MacBook-Pro";
  system.stateVersion = 6;
  time.timeZone = "Europe/London";

  # Headless aarch64-linux builder. This does not build x86_64 packages for the PC.
  nix.linux-builder.enable = true;

  # --- Garbage collection ---
  nix.gc.interval = {
    Weekday = 0;
    Hour = 3;
    Minute = 0;
  };
}
