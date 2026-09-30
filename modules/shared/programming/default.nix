{ pkgs, lib, ... }:
{
  # Languages and JetBrains IDEs on both machines. On the Mac, FreeCAD,
  # Android Studio, and Autodesk Fusion are Homebrew casks in
  # modules/darwin/homebrew.nix.
  #
  # nixpkgs 26.05 no longer resolves marketplace plugin ids inside
  # addPlugins, and it does not ship those plugins. Install Dart and
  # themes from the IDE.

  environment.systemPackages = [
    # --- JetBrains ---
    pkgs.jetbrains.idea
    pkgs.jetbrains.pycharm

    # --- Languages / build ---
    pkgs.cmake
    pkgs.pkg-config
    pkgs.nodejs
    pkgs.pnpm
    pkgs.go
    pkgs.python3
    pkgs.php
    pkgs.phpPackages.composer
    pkgs.ruby
    pkgs.gradle
    pkgs.maven
    pkgs.deno
    pkgs.flutter
    pkgs.dotnet-sdk
    pkgs.android-tools
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.android-studio
    pkgs.freecad
  ];
}
