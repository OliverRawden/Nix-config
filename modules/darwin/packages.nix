{ pkgs, ... }:
{
  # Mac-only Nix packages. Shared CLI is in modules/shared; languages
  # and IDEs are in modules/shared/programming.
  environment.systemPackages = with pkgs; [
    zed-editor
    protonmail-desktop
    gptfdisk
    lima
    qemu
    docker
    xquartz
    dnscrypt-proxy
  ];
}
