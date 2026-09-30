# The account that owns this Mac. username comes from flake.nix.
{ pkgs, username, ... }:
{
  system.primaryUser = username;
  users.knownUsers = [ username ];
  users.users.${username} = {
    home = "/Users/${username}";
    # 501 is the first account created by macOS Setup.
    uid = 501;
    shell = pkgs.fish;
  };
}
