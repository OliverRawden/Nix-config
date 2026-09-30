{ lib, pkgs, ... }:
let
  jdkDefault = pkgs.jdk25 or pkgs.jdk;
  jdk21 = pkgs.jdk21;
in {
  # nix-darwin only executes its built-in activation script names.
  # Anything else is stored on the option and never run.
  # Leave the Oracle jdk-25.jdk directory and the Homebrew JDKs alone.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    jvms=/Library/Java/JavaVirtualMachines
    mkdir -p "$jvms"
    link_jdk() {
      local src="$1" name="$2"
      if [ ! -e "$src" ]; then
        return
      fi
      if [ -d "$jvms/$name" ] && [ ! -L "$jvms/$name" ]; then
        return
      fi
      ln -sfn "$src" "$jvms/$name"
    }
    link_jdk "${jdk21.bundle}" openjdk-21.jdk
    link_jdk "${jdkDefault.bundle}" openjdk-25.jdk
  '';
}
