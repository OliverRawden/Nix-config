{ lib, username, ... }:
{
  # --- Analytics ---
  # The fuller set lives in macos-disable-telemetry.sh, which macOS 26
  # needs re-applied on a timer. This covers a rebuild before that job runs.
  # Custom activation script names are not executed. Use postActivation.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    uid="$(id -u ${username})"
    disable_sys() { launchctl disable "system/$1" 2>/dev/null || true; }
    disable_gui() { launchctl disable "gui/''${uid}/$1" 2>/dev/null || true; }
    disable_sys com.apple.analyticsd
    disable_sys com.apple.osanalytics.osanalyticshelper
    disable_sys com.apple.SubmitDiagInfo
    disable_sys com.apple.rtcreportingd
    disable_sys com.apple.wifianalyticsd
    disable_gui com.apple.UsageTrackingAgent
  '';
}
