{ pkgs, lib, ... }:
let
  mod = if pkgs.stdenv.hostPlatform.isDarwin then "cmd" else "super";
  macos =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "macos-auto-secure-input = false"
    else "";

  ghosttyConfig = builtins.replaceStrings
    [ "__MOD__" "__MACOS__" ]
    [ mod macos ]
    (builtins.readFile ./files/ghostty/config);
in {
  xdg.configFile."ghostty/config".text = ghosttyConfig;

  home.file."Library/Application Support/com.mitchellh.ghostty/config" =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin { text = ghosttyConfig; };
}
