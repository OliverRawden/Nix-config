# PC only. hosts/nixos/pc imports this plus modules/shared.
{ lib, pkgs, username, ... }:
let
  locale = "en_GB.UTF-8";
in {
  imports = [
    ./desktop.nix
    ../shared/programming
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Network ---
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # --- Locale ---
  time.timeZone = "Europe/London";
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = lib.genAttrs [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ] (_: locale);
  console.keyMap = "uk";

  # --- Audio ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Account ---
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "docker" "wireshark" ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = true;

  # --- Graphics ---
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # --- Services ---
  programs.nix-ld.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  virtualisation.docker.enable = true;
  services.ollama.enable = true;
  nix.gc.dates = "weekly";
}
