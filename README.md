# nix-darwin

nix-darwin and home-manager for this Mac: Apple Silicon, hostname `MacBook-Pro`, user `rawden`.

```
flake.nix                      inputs and darwinConfigurations."MacBook-Pro"
modules/default.nix            system module list — add a file here to include it
modules/host.nix               hostname, timezone, garbage collection
modules/nix.nix                Nix daemon
modules/user.nix               account
modules/packages.nix           CLI tools, Java, and Mac packages
modules/programming.nix        languages and JetBrains IDEs
modules/shell.nix              fish, SSH, direnv, nix-index
modules/fonts.nix              fonts
modules/homebrew.nix           casks Nix does not ship
modules/defaults.nix           System Settings
modules/control-center.nix     menu bar and Control Center layout
modules/windows.nix            Hyper window and desktop shortcuts
modules/jdk.nix                Nix JDK links
modules/telemetry.nix          analytics daemons disabled on each rebuild
modules/home/                  home-manager
modules/home/files/            dotfiles installed into ~/.config
```

## Fresh macOS install

1. Install the official multi-user Nix: <https://nixos.org/download/>
2. Install Homebrew: <https://brew.sh>. nix-darwin manages the casks but does not install Homebrew itself. Without it, activation skips the cask list.
3. Copy this repo to `/etc/nix-darwin`. The first user created by Setup must be `rawden` (uid 501).
4. First switch, which also provides `darwin-rebuild`:

   ```bash
   sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake /etc/nix-darwin#MacBook-Pro
   ```

5. Later switches:

   ```bash
   sudo darwin-rebuild switch
   ```

`darwin-rebuild` with no `--flake` builds the flake at `/etc/nix-darwin`. `networking.localHostName` in `modules/host.nix` must stay `MacBook-Pro`, matching the flake output name.

Leave `system.stateVersion` at `6`. nix-darwin uses it for migration defaults.

## Day to day

Edit the file that owns the setting, then run `sudo darwin-rebuild switch`. Files home-manager replaces are kept beside the new file with the suffix `hm-bak`.

| Want to change | Edit |
| --- | --- |
| A Nix package | `modules/packages.nix` |
| A language or JetBrains IDE | `modules/programming.nix` |
| A Homebrew cask | `modules/homebrew.nix` |
| A font | `modules/fonts.nix` |
| Dock, Finder, keyboard, menu bar | `modules/defaults.nix` |
| Control Center layout | `modules/control-center.nix` and `modules/control-center/bentoboxes.plist` |
| Hyper shortcuts | `modules/windows.nix` |
| Fish, git, nvim, Ghostty, Zed, … | `modules/home/files/<app>` |

To track another app's config, add its directory under `modules/home/files/` and its name to the list in `modules/home/dotfiles.nix`.

## Packages

CLI tools, JetBrains IDEs, Zed, and most other packages come from Nix. Homebrew is only for apps that are missing or Linux-only in nixpkgs on this Mac: Zen, Ghostty, nheko, Raycast, Karabiner-Elements, Autodesk Fusion, Android Studio, and FreeCAD. `cleanup` is `none`, so leftover brew formulae are not uninstalled.

Nix JDKs are linked into `/Library/Java/JavaVirtualMachines` as `openjdk-21.jdk` and `openjdk-25.jdk`. The Oracle `jdk-25.jdk` bundle and any Homebrew JDKs are left in place. `JAVA_HOME` is Nix JDK 25. Zed's Java language server uses the Oracle JDK 25 bundle.

`nix.linux-builder` builds `aarch64-linux` packages on this Mac.

## Keyboard

Caps Lock is Escape when tapped and Hyper (Control, Option, Shift, Command) when held, via Karabiner-Elements. Command-Space opens Raycast. Hyper-1 through Hyper-4 switch desktops. Hyper-H/J/K/L tile left, down, up, and right. Hyper-R returns the previous size, Hyper-D centres, and Hyper-F fills. Shift-Option-D shows the desktop.

## Dotfiles

App configs live in this flake at `modules/home/files/`. Home-manager installs them into `~/.config`. Edit the files here, then rebuild.

Ghostty's config is `modules/home/files/ghostty/config.ghostty`. The same file is also installed where the Homebrew app reads it: `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`.

Secrets stay on the machine and are not in this tree: `~/.config/gh/hosts.yml`, Wireshark keys, and the rclone config. The restic password for `proton-sync` is in the macOS Keychain under `restic-proton-macos`.
