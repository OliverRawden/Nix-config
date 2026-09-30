{ pkgs, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./ghostty.nix
    ./zed.nix
    ./keyboard.nix
  ];

  # --- Identity ---
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
  home.stateVersion = "26.05";

  home.file.".zshenv".text = ''
    export ZDOTDIR="$HOME/.config/zsh"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  '';
}
