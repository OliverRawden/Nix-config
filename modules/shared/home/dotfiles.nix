{ lib, ... }:
{
  xdg.enable = true;

  # Config files live in this flake under ./files. recursive = true keeps
  # each app directory real so tools can still write local state
  # (fish_variables, gh/hosts.yml, …). Zed is generated in ./zed.nix so
  # the JDK path can follow the host.
  xdg.configFile =
    lib.genAttrs [
      "btop"
      "cava"
      "cliamp"
      "cursor"
      "fastfetch"
      "fish"
      "gh"
      "git"
      "nvim"
      "opencode"
      "scripts"
      "tmux"
      "unmenu"
      "wireshark"
      "zsh"
    ] (name: {
      source = ./files + "/${name}";
      recursive = true;
    })
    // {
      "starship.toml".source = ./files/starship.toml;
    };
}
