{ pkgs, username, ... }:
{
  # --- Account ---
  system.primaryUser = username;
  users.knownUsers = [ username ];
  users.users.${username} = {
    home = "/Users/${username}";
    uid = 501;
    shell = pkgs.fish;
  };
}
