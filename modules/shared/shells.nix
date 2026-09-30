{ pkgs, ... }:
{
  programs.fish.enable = true;
  # nix-darwin does not add users.users.*.shell to /etc/shells by itself.
  environment.shells = [ pkgs.fish ];
}
