# System packages. Languages and JetBrains IDEs live in programming.nix.
# Apps Nix does not ship on Darwin live in homebrew.nix.
{ pkgs, lib, ... }:
let
  # pkgs.jdk on this nixpkgs is still 21, so pin 25 explicitly.
  jdkDefault = pkgs.jdk25 or pkgs.jdk;
in {
  environment.systemPackages = with pkgs; [
    # --- Editors / VCS ---
    vim
    neovim
    git
    gh

    # --- Search / navigation ---
    ripgrep
    fd
    eza
    fzf
    zoxide
    yazi

    # --- Terminal ---
    tmux
    starship
    fastfetch
    zsh-autosuggestions

    # --- Monitoring ---
    htop
    btop

    # --- Network / media ---
    curl
    jq
    yt-dlp
    ffmpeg
    nmap
    rclone
    restic

    # --- Java ---
    # hiPrio keeps JDK 25 ahead of jdk21 on PATH.
    (lib.hiPrio jdkDefault)
    jdk21

    # --- Mac ---
    zed-editor
    protonmail-desktop
    gptfdisk
    lima
    qemu
    docker
    xquartz
    dnscrypt-proxy
    ollama
    wireshark
  ];

  environment.variables.JAVA_HOME = "${jdkDefault}";
}
