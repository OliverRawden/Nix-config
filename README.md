# nix-config

Shared flake for the Mac (nix-darwin) and the custom PC (NixOS).

```
flake.nix                         inputs and host wiring
hosts/darwin/MacBook-Pro/         this Mac
hosts/nixos/pc/                   NixOS PC — replace hardware.nix on first install
modules/darwin/                   Mac only: Homebrew, Dock, menu bar, JDK links
modules/nixos/                    PC only: boot, Plasma, Steam, Docker
modules/shared/                   both: Nix, CLI, fish, fonts
modules/shared/programming/       both: languages and JetBrains IDEs
modules/shared/home/              both: home-manager
modules/shared/home/files/        fish, nvim, git, Ghostty, … (in-tree, not a GitHub input)
```

## This Mac

```bash
sudo darwin-rebuild switch
```

Edit this tree, review it, then copy it to `/etc/nix-darwin`.
`darwin-rebuild` with no `--flake` builds whatever is at that path.
LocalHostName is `MacBook-Pro`, matching `darwinConfigurations`.

CLI, JetBrains IDEs, Zed, and most GUI apps come from Nix. Homebrew is
only for apps that are missing or Linux-only in nixpkgs on this Mac: Zen,
Ghostty, nheko, Raycast, Autodesk Fusion, Android Studio, and FreeCAD. `cleanup`
is `none`, so leftover brew formulae are not uninstalled.

Nix JDKs are linked into `/Library/Java/JavaVirtualMachines` as
`openjdk-21.jdk` and `openjdk-25.jdk`. The Oracle `jdk-25.jdk` bundle
and the Homebrew JDKs are left in place. `JAVA_HOME` is Nix JDK 25.

Caps Lock is Escape when tapped and Hyper (Control, Option, Shift, Command)
when held, via Karabiner-Elements. Command-Space opens Raycast. The other
shortcuts are the macOS ones in System Settings: Hyper-1 through Hyper-4
switch desktops, Hyper-H/J/K/L tile left, down, up, and right, Hyper-R
returns the previous size, Hyper-D centres, and Hyper-F fills.
Shift-Option-D shows the desktop.
`nix.linux-builder` builds `aarch64-linux` packages on this Mac. SSH adds
keys to the Keychain agent. direnv and nix-index hook the shell.

## NixOS PC

Intel i5 + RX 7800 XT. Hostname is `pc`.

1. Copy this repo onto the PC.
2. Replace `hosts/nixos/pc/hardware.nix`:

   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/nixos/pc/hardware.nix
   ```

3. Set a password (`users.mutableUsers` is on):

   ```bash
   sudo passwd rawden
   ```

   On a first install, add `hashedPassword` from `mkpasswd -m sha-512` under
   `users.users.rawden` in `modules/nixos/default.nix`.

4. Apply:

   ```bash
   sudo nixos-rebuild switch --flake .#pc
   ```

Rename the hostname in `hosts/nixos/pc/default.nix` if you want. The flake output
name stays `pc` unless you also change `nixosConfigurations."pc"`.

## Dotfiles

App configs live **in this flake** at `modules/shared/home/files/`. Home-manager
installs them into `~/.config`. There is no GitHub `dotfiles` flake input
and no `~/dotfiles` clone.

Ghostty is `modules/shared/home/files/ghostty/config` (`cmd` on macOS, `super`
on Linux). Edit files in the flake, then rebuild.

Secrets (`gh/hosts.yml`, Wireshark keys, rclone) stay on the machine and
are not in the tree.
