# Desktop switching and the system Window menu.
# Hyper is Control, Option, Shift, and Command together.
{ lib, ... }:
let
  # Same records System Settings writes into com.apple.symbolichotkeys.
  # The third number is the modifier mask: shift 131072, control 262144,
  # option 524288, command 1048576. Hyper is all four: 1966080.
  hotkey = enabled: parameters:
    if parameters == null
    then { inherit enabled; }
    else {
      inherit enabled;
      value = {
        inherit parameters;
        type = "standard";
      };
    };

  # Existing shortcuts on this Mac, plus the ones this config owns:
  # 36 show desktop (shift-option-d), 64 Spotlight off, 118–121 desktops on Hyper-1–4.
  symbolicHotKeys = lib.listToAttrs (map (entry: {
    name = toString (builtins.elemAt entry 0);
    value = hotkey (builtins.elemAt entry 1) (builtins.elemAt entry 2);
  }) [
    [ 15 false null ] [ 16 false null ] [ 17 false null ] [ 18 false null ]
    [ 19 false null ] [ 20 false null ] [ 21 false null ] [ 22 false null ]
    [ 23 false null ] [ 24 false null ] [ 25 false null ] [ 26 false null ]
    [ 32 true [ 106 38 262144 ] ]
    [ 33 true [ 107 40 262144 ] ]
    [ 34 true [ 106 38 393216 ] ]
    [ 35 true [ 107 40 393216 ] ]
    [ 36 true [ 100 2 655360 ] ]
    [ 37 false [ 65535 103 8519680 ] ]
    [ 60 false [ 32 49 262144 ] ]
    [ 61 false [ 32 49 786432 ] ]
    [ 64 false [ 32 49 1048576 ] ]
    [ 65 false [ 32 49 1572864 ] ]
    [ 79 true [ 104 4 262144 ] ]
    [ 80 true [ 104 4 393216 ] ]
    [ 81 true [ 108 37 262144 ] ]
    [ 82 true [ 108 37 393216 ] ]
    [ 118 true [ 49 18 1966080 ] ]
    [ 119 true [ 50 19 1966080 ] ]
    [ 120 true [ 51 20 1966080 ] ]
    [ 121 true [ 52 21 1966080 ] ]
    [ 164 false [ 65535 65535 0 ] ]
    [ 233 true [ 109 46 1048576 ] ]
    [ 235 true [ 65535 65535 0 ] ]
    [ 237 true [ 102 3 1966080 ] ]
    [ 238 true [ 100 2 1966080 ] ]
    [ 239 true [ 114 15 1966080 ] ]
    [ 240 false [ 65535 123 8650752 ] ]
    [ 241 false [ 65535 124 8650752 ] ]
    [ 242 false [ 65535 126 8650752 ] ]
    [ 243 false [ 65535 125 8650752 ] ]
    [ 244 false [ 65535 65535 0 ] ]
    [ 245 false [ 65535 65535 0 ] ]
    [ 246 false [ 65535 65535 0 ] ]
    [ 247 false [ 65535 65535 0 ] ]
    [ 248 true [ 104 4 1966080 ] ]
    [ 249 true [ 108 37 1966080 ] ]
    [ 250 true [ 107 40 1966080 ] ]
    [ 251 true [ 106 38 1966080 ] ]
    [ 256 true [ 65535 65535 0 ] ]
    [ 257 false [ 65535 65535 0 ] ]
    [ 258 false [ 65535 65535 0 ] ]
  ]);

  # System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts.
  # Hyper includes Shift, so the letter is uppercase.
  hyper = "^~$@";
  windowShortcut = title: key: {
    name = title;
    value = "${hyper}${key}";
  };
  moveResize = name: key: [
    (windowShortcut "Window->Move & Resize->${name}" key)
    (windowShortcut "Window->Full Screen Tile->${name}" key)
  ];
in {
  # App Shortcuts for the system Window menu. This is the tiling macOS already has.
  system.defaults.CustomUserPreferences."-g".NSUserKeyEquivalents = lib.listToAttrs (
    [
      (windowShortcut "Window->Fill" "F")
      (windowShortcut "Window->Center" "D")
    ]
    ++ moveResize "Left" "H"
    ++ moveResize "Right" "L"
    ++ moveResize "Top" "K"
    ++ moveResize "Bottom" "J"
    ++ moveResize "Return to Previous Size" "R"
  );

  # Mission Control, Spotlight, and desktop switching. Same plist System Settings edits.
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = symbolicHotKeys;
}
