# Fonts installed for every user. Add a package to the list.
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];
}
