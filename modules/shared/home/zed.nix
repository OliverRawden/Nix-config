{ pkgs, ... }:
let
  jdk25 = pkgs.jdk25 or pkgs.jdk;
  # The Mac link is stable across JDK updates. Linux uses the store path
  # because there is no /Library/Java tree.
  javaHome =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Library/Java/JavaVirtualMachines/jdk-25.jdk/Contents/Home"
    else "${jdk25}";
in {
  xdg.configFile."zed/settings.json".text =
    builtins.replaceStrings [ "__JDK25_HOME__" ] [ javaHome ]
      (builtins.readFile ./files/zed/settings.json);
}