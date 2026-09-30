{ lib, username, ... }:
let
  asUser = ''launchctl asuser "$(id -u ${username})" sudo --user=${username} --'';
in {
  # --- Control Center (Tahoe System Services panel) ---
  #
  #   Wi-Fi (2)              Now Playing (2×2)
  #   Bluetooth (2)          (Now Playing)
  #   AirDrop  Screen Mirror Recognise Music (2)
  #   Focus    Brightness    Stage Manager (2)
  #   Display slider (4)
  #   Sound slider (4)
  #   Keyboard brightness (2)  Proton Drive Backup (2)
  #
  # Layout is the bentoboxes.plist snapshot. Menu Bar toggles such as
  # Time Machine live in the Control Center group container on Tahoe.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    dest_dir="/Users/${username}/Library/Preferences/ByHost"
    src="${./control-center/bentoboxes.plist}"
    mkdir -p "$dest_dir"

    uuid=""
    for f in "$dest_dir"/com.apple.controlcenter.*.plist; do
      [ -e "$f" ] || continue
      base="''${f##*/}"
      case "$base" in
        com.apple.controlcenter.bentoboxes.*|com.apple.controlcenter.displayablemenuextras.*)
          continue
          ;;
      esac
      uuid="''${base#com.apple.controlcenter.}"
      uuid="''${uuid%.plist}"
      break
    done
    if [ -z "$uuid" ]; then
      uuid=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')
    fi
    if [ -n "$uuid" ]; then
      dest="$dest_dir/com.apple.controlcenter.bentoboxes.$uuid.plist"
      cp "$src" "$dest"
      chown ${username}:staff "$dest"
      chmod 600 "$dest"
    fi

    ${asUser} defaults -currentHost write com.apple.controlcenter KeyboardBrightness -int 9
    ${asUser} defaults -currentHost write com.apple.controlcenter MusicRecognition -int 1
    ${asUser} defaults -currentHost write com.apple.controlcenter StageManager -int 8

    cc_group="/Users/${username}/Library/Group Containers/group.com.apple.controlcenter/Library/Preferences/group.com.apple.controlcenter"
    mkdir -p "$(dirname "$cc_group")"
    ${asUser} defaults write "$cc_group" showTimeMachine -bool true
    ${asUser} defaults write "$cc_group" showVPN -bool false
    ${asUser} defaults write "$cc_group" showWeather -bool false

    killall -qu ${username} ControlCenter 2>/dev/null || true
    killall -qu ${username} MenuBarAgent 2>/dev/null || true
    killall -qu ${username} SystemUIServer 2>/dev/null || true
  '';
}
