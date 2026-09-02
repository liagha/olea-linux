# Olea Linux

A minimal Arch-based Linux distribution with Sway.

## Building

Requires `archiso` and `dosfstools`:

```bash
sudo pacman -S archiso dosfstools
```

Build the ISO:

```bash
./scripts/build.sh
```

The ISO is written to `out/` with a version derived from the latest git tag
(or commit).

## Installing

Boot the ISO on a UEFI machine (at least 2 GB of memory, 20 GB of disk), log
in as root and run:

```bash
/root/install.sh
```

The installer walks through:

- disk selection (the whole disk is wiped — GPT with a 512 MB ESP and a root
  partition)
- optional LUKS encryption of the root partition
- optional hardening of the pacman mirrorlist with reflector (Iran)
- base system, locale, keymap, timezone, hostname
- optional zram swap and an optional hibernation swapfile (sized on RAM by
  default; the `resume` hooks and boot options are configured automatically)
- root and user accounts (the user is added to `wheel` and can use `sudo`)
- systemd-boot and a fixed network/audio service set
- the stock Olea desktop configs (Sway, Waybar, Foot, Zsh)

Then unmount and reboot:

```bash
umount -R /mnt
reboot
```

The install can be scripted by supplying the following environment
variables: `OLEA_DISK`, `OLEA_HOST`, `OLEA_USER`, `OLEA_TZ`, `OLEA_LOCALE`,
`OLEA_KEYMAP`, `OLEA_ENCRYPT`, `OLEA_PASS`, `OLEA_PASS_USER`, `OLEA_SWAP`,
`OLEA_YES`. In scripted mode (stdin is not a terminal) every answer defaults
to its sensible value and `OLEA_YES` accepts all confirmations.

## Stack

- **Window Manager:** Sway
- **Bar:** Waybar
- **Terminal:** Foot
- **Shell:** Zsh
- **Launcher:** Wofi
- **Notifications:** Mako
- **Wallpaper:** Black
- **Boot:** systemd-boot

## Keybindings

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal |
| `Mod+d` | App launcher |
| `Mod+h/j/k/l` | Focus |
| `Mod+Shift+h/j/k/l` | Move |
| `Mod+1-9` | Workspace |
| `Mod+f` | Fullscreen |
| `Mod+Space` | Float |
| `Mod+p` | Resize mode |
| `Print` | Screenshot |