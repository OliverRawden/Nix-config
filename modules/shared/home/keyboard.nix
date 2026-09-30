{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    xdg.configFile."karabiner/karabiner.json".source = ./files/karabiner/karabiner.json;
  };
}
