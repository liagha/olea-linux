# Olea Linux

A minimal Arch-based Linux distribution with Sway.

## Building

Requires `archiso` installed:

```bash
sudo pacman -S archiso
```

Build the ISO:

```bash
sudo ./scripts/build.sh
```

The ISO will be in `out/`.

## Installing

Boot from the ISO and run:

```bash
./scripts/install.sh
```

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
