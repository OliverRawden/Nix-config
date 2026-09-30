# System Settings: Dock, Finder, keyboard, trackpad, menu bar, and windows.
# Anything nix-darwin has no option for is written in postActivation.
{ username, lib, ... }:
{
  security.pam.services.sudo_local.touchIdAuth = true;

  # Firewall on, plus the three toggles: built-in software, downloaded signed
  # software, and stealth mode. Incoming connections are still filtered per app.
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  # %00 plays the startup sound. A non-zero value mutes it.
  # nix-darwin writes this during activation; dropping the line does not restore the old value.
  system.nvram.variables.StartupMute = "%00";

  # A custom folder tint would override the Blue folder colour.
  # power.sleep cannot split charger and battery, so sleep uses pmset.
  # Screensaver idle time is in the ByHost domain, written as the logged-in user.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    launchctl asuser "$(id -u ${username})" sudo --user=${username} -- defaults delete -g AppleIconAppearanceCustomTintColor 2>/dev/null || true

    launchctl asuser "$(id -u ${username})" sudo --user=${username} -- defaults -currentHost write com.apple.screensaver idleTime -int 300

    # Charger: never. Battery: 10 minutes. Disk sleep is left as it is.
    pmset -c sleep 0 displaysleep 0
    pmset -b sleep 10 displaysleep 10
  '';


  system.defaults = {
    # --- Dock ---
    dock = {
      orientation = "left";
      autohide = false;
      show-recents = false;
      mru-spaces = false;
      # 2% under the previous 48 and 62. Sizes are whole pixels.
      tilesize = 47;
      magnification = true;
      largesize = 61;
      # Genie: the window collapses into the Dock like a genie into a lamp.
      mineffect = "genie";
      showMissionControlGestureEnabled = true;
      minimize-to-application = true;
      launchanim = true;
      show-process-indicators = true;
      # Group windows by application in Mission Control.
      expose-group-apps = true;
      persistent-apps = [
        { app = "/Applications/Zen.app"; }
        { app = "/Applications/Ghostty.app"; }
        { app = "/System/Applications/Messages.app"; }
        { app = "/Applications/Nix Apps/Proton Mail.app"; }
        { app = "/Applications/Nix Apps/Zed.app"; }
        { app = "/System/Applications/Music.app"; }
        { app = "/System/Applications/System Settings.app"; }
      ];
    };

    # --- Finder ---
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    # --- Keyboard / UI ---
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      _HIHideMenuBar = false;
      NSStatusItemSpacing = 12;
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      # Dark icons, Always. RegularAutomatic would follow light and dark mode.
      AppleIconAppearanceTheme = "RegularDark";
      # When scrolling. Clicking the scrollbar jumps to the next page.
      AppleShowScrollBars = "WhenScrolling";
      AppleScrollerPagingBehavior = false;
      # Medium sidebar icons.
      NSTableViewDefaultSizeMode = 2;
      # Prefer tabs in full screen.
      AppleWindowTabbingMode = "fullscreen";
      # Switch to a Space that already has a window for the app.
      AppleSpacesSwitchOnActivate = true;
      # Alert volume at full. 1 plays the volume-change click.
      "com.apple.sound.beep.volume" = 1.0;
      "com.apple.sound.beep.feedback" = 1;
    };

    # --- Menu bar clock ---
    # Digital time with a flashing colon; no date, day, seconds, or AM/PM.
    menuExtraClock = {
      FlashDateSeparators = true;
      IsAnalog = false;
      Show24Hour = false;
      ShowAMPM = false;
      ShowDate = 2;
      ShowDayOfWeek = false;
      ShowSeconds = false;
    };

    # --- Menu bar extras (show when active → appear to the left of pinned items) ---
    controlcenter = {
      BatteryShowPercentage = false;
      AirDrop = false;
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    # --- Trackpad ---
    # Three-finger drag uses the same gesture as these swipes, so it stays off.
    # Horizontal 2 switches desktops; vertical 2 is Mission Control (swipe up).
    # Four-finger copies are off so macOS uses three fingers.
    trackpad = {
      Clicking = false;
      TrackpadThreeFingerDrag = false;
      TrackpadThreeFingerHorizSwipeGesture = 2;
      TrackpadFourFingerHorizSwipeGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 0;
    };

    # Each display has its own Spaces. Takes effect after logout.
    # macOS does not store a desktop count. The four desktops already on this
    # Mac are the ones Hyper-1 through Hyper-4 switch.
    spaces.spans-displays = false;

    # Edge drag, menu-bar fill, and Option-drag tile. Tiled windows have no margins.
    # Dragging a window to the top of the screen opens Mission Control (dock key below).
    # Stage Manager is off. Its strip shows recent apps, with every window of an app at once.
    # Desktop items stay hidden. Clicking the wallpaper always shows the desktop.
    # Widgets show on the desktop and in Stage Manager.
    WindowManager = {
      EnableTilingByEdgeDrag = true;
      EnableTopTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true;
      EnableTiledWindowMargins = false;
      GloballyEnabled = false;
      AutoHide = false;
      AppWindowGroupingBehavior = true;
      EnableStandardClickToShowDesktop = true;
      StandardHideDesktopIcons = true;
      HideDesktop = true;
      StandardHideWidgets = false;
      StageManagerHideWidgets = false;
    };

    # Desktop is the save folder. Shift-Command-3, 4, and 5 stay the macOS
    # defaults; those shortcut ids are not in the symbolic hotkey table.
    screencapture = {
      location = "/Users/${username}/Desktop";
      target = "file";
    };

    universalaccess.reduceTransparency = false;

    CustomUserPreferences = {
      # --- Appearance ---
      NSGlobalDomain = {
        "com.apple.SwiftUI.DisableSolarium" = false;
        # 5 = Purple. Highlight matches the accent.
        AppleAccentColor = 5;
        AppleHighlightColor = "0.968627 0.831373 1.000000 Purple";
        AppleAquaColorVariant = 1;
        # Double-click a title bar fills the window.
        AppleActionOnDoubleClick = "Fill";
        # Ask before discarding unsaved changes.
        NSCloseAlwaysConfirmsChanges = true;
        # Quit closes the windows, so reopening an app does not restore them.
        NSQuitAlwaysKeepsWindows = false;
        # Wallpaper does not tint window backgrounds.
        AppleReduceDesktopTinting = true;
        # Folder colour Blue. A custom tint is cleared in postActivation.
        AppleIconAppearanceTintColor = "Blue";
        # System Settings labels this file Pluck.
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Purr.aiff";
        # Play user interface sound effects.
        "com.apple.sound.uiaudio.enabled" = 1;
      };

      # macOS 27 stores the screenshot destination here.
      "com.apple.screencapture" = {
        "target-screenshot" = "file";
      };

      # Drag a window to the top of the screen to open Mission Control.
      "com.apple.dock" = {
        enterMissionControlByTopWindowDrag = true;
      };

      # 0 is Always: desktop widgets stay monochrome.
      "com.apple.widgets" = {
        widgetAppearance = 0;
      };

      # --- Privacy ---
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      # --- Pinned menu bar items (from the right: clock, Spotlight, Control Center, battery, Wi-Fi) ---
      "com.apple.controlcenter" = {
        "NSStatusItem VisibleCC Clock" = true;
        "NSStatusItem VisibleCC BentoBox" = true;
        "NSStatusItem VisibleCC BentoBox-0" = true;
        "NSStatusItem VisibleCC Battery" = true;
        "NSStatusItem VisibleCC WiFi" = true;
        "NSStatusItem Visible Shortcuts" = false;
        "NSStatusItem Visible AudioVideoModule" = false;
        "NSStatusItem Visible MusicRecognition" = false;
        "NSStatusItem Preferred Position BentoBox" = 80;
        "NSStatusItem Preferred Position BentoBox-0" = 90;
        "NSStatusItem Preferred Position Battery" = 160;
        "NSStatusItem Preferred Position WiFi" = 240;
      };

      "com.apple.Spotlight" = {
        MenuItemHidden = false;
      };

      # Time Machine stays out of the menu bar. VPN stays hidden.
      "com.apple.systemuiserver" = {
        "NSStatusItem Visible com.apple.menuextra.TimeMachine" = false;
        "NSStatusItem VisibleCC com.apple.menuextra.TimeMachine" = false;
        "NSStatusItem Visible com.apple.menuextra.vpn" = false;
        "NSStatusItem VisibleCC com.apple.menuextra.vpn" = false;
        menuExtras = [ ];
      };
    };
  };
}
