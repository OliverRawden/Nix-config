# Mac only. hosts/darwin/MacBook-Pro imports this plus modules/shared.
{
  imports = [
    ./user.nix
    ./packages.nix
    ./homebrew.nix
    ../shared/programming
    ./defaults.nix
    ./control-center.nix
    ./jdk.nix
    ./telemetry.nix
    ./shell.nix
    ./windows.nix
  ];
}
