{
  # macOS ssh reads this after ~/.ssh/config. Private keys stay on the machine.
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
    UseKeychain yes
  '';

  programs.direnv.enable = true;

  # The module's shell hook is bash. Fish uses functions/fish_command_not_found.fish.
  programs.nix-index.enable = true;
}
