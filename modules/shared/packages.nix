{ pkgs, lib, ... }:
let
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
    # hiPrio keeps JDK 25 ahead of jdk21 on PATH. pkgs.jdk on this
    # nixpkgs is still 21, so pin jdk25 explicitly.
    (lib.hiPrio jdkDefault)
    jdk21
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (with pkgs; [
    # The NixOS module installs services.ollama.package (ollama-rocm).
    ollama
    # Linux capture goes through programs.wireshark, which wraps dumpcap.
    wireshark
  ]);

  environment.variables.JAVA_HOME = "${jdkDefault}";
}
