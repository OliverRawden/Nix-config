# Login shell and the programs that hook into it.
{ pkgs, ... }:
{
  # --- Login shell ---
  programs.fish.enable = true;
  # nix-darwin does not add users.users.*.shell to /etc/shells by itself.
  environment.shells = [ pkgs.fish ];

  # --- SSH ---
  # macOS ssh reads this after ~/.ssh/config. Private keys stay on the machine.
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
    UseKeychain yes
  '';

  # --- Per-directory environments ---
  programs.direnv.enable = true;

  # The module's command-not-found hook is bash.
  # Fish uses modules/home/files/fish/functions/fish_command_not_found.fish.
  programs.nix-index.enable = true;
}
