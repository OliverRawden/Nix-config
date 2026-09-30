# home-manager for the macOS user. username comes from flake.nix.
{ username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./ghostty.nix
  ];

  # --- Identity ---
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.05";

  # Zsh reads this before the config installed under ~/.config/zsh.
  home.file.".zshenv".text = ''
    export ZDOTDIR="$HOME/.config/zsh"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  '';
}
