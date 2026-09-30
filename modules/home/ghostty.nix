# Ghostty 1.3 reads config.ghostty. The file under ~/.config/ghostty
# comes from dotfiles.nix. The Homebrew app reads the Application Support
# path below. Edit files/ghostty/config.ghostty; both copies follow it.
{ ... }:
{
  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty".source =
    ./files/ghostty/config.ghostty;
}
