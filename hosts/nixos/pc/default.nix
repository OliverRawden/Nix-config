{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../../../modules/shared
    ../../../modules/nixos
  ];

  # --- Identity ---
  networking.hostName = "pc";
  system.stateVersion = "26.05";

  # --- GPU: Radeon RX 7800 XT (RDNA 3, gfx1101) ---
  # hardware.graphics.enable (modules/nixos) already installs Mesa's
  # Vulkan and VA-API drivers. libva is the loader, not a driver.
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.opencl.enable = true;

  # --- Ollama (ROCm). gfx1101 is not always auto-detected. ---
  services.ollama.package = pkgs.ollama-rocm;
  services.ollama.rocmOverrideGfx = "11.0.1";
}
