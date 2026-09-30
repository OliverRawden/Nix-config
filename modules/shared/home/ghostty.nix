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
  # Ghostty 1.3 reads config.ghostty. The legacy name "config" is still
  # loaded first when it exists, so only the new name is installed.
  xdg.configFile."ghostty/config.ghostty".text = ghosttyConfig;

  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty" =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin { text = ghosttyConfig; };
}
