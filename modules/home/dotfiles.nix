# Dotfiles from ./files, installed into ~/.config.
{ lib, ... }:
{
  xdg.enable = true;

  # recursive = true keeps each app directory real, so tools can still
  # write local state next to these files (fish_variables, gh/hosts.yml, …).
  #
  # To track another app: create ./files/<name> and add <name> below.
  # Ghostty's Homebrew app path is mirrored from the same files in ghostty.nix.
  xdg.configFile =
    lib.genAttrs [
      "btop"
      "cava"
      "cliamp"
      "cursor"
      "fastfetch"
      "fish"
      "gh"
      "ghostty"
      "git"
      "karabiner"
      "nvim"
      "opencode"
      "scripts"
      "tmux"
      "unmenu"
      "wireshark"
      "zed"
      "zsh"
    ] (name: {
      source = ./files + "/${name}";
      recursive = true;
    })
    // {
      "starship.toml".source = ./files/starship.toml;
    };
}
