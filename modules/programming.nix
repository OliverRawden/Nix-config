# Languages and JetBrains IDEs.
# FreeCAD, Android Studio, and Autodesk Fusion are Homebrew casks
# in homebrew.nix.
#
# nixpkgs 26.05 no longer resolves marketplace plugin ids inside
# addPlugins, and it does not ship those plugins. Install Dart and
# themes from the IDE.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # --- JetBrains ---
    jetbrains.idea
    jetbrains.pycharm

    # --- Languages / build ---
    cmake
    pkg-config
    nodejs
    pnpm
    go
    python3
    php
    phpPackages.composer
    ruby
    gradle
    maven
    deno
    flutter
    dotnet-sdk
    android-tools
  ];
}
