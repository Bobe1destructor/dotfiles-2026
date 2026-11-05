# dotfiles-2026

Arch Linux + Hyprland dotfiles. The installer is designed to preserve existing user configuration.

## Install

```bash
git clone https://github.com/Bobe1destructor/dotfiles-2026.git
cd dotfiles-2026
git switch fix/arch-hyprland-installation
chmod +x install.sh
./install.sh
```

The installer performs a full Arch package upgrade, installs packages listed in `packages/pacman.txt`, creates timestamped backups of conflicting `~/.config` entries and `~/.zshrc`, and creates symlinks to this repository. It does not replace NVIDIA drivers or install an AUR helper.

## Optional wallpaper integration

`swww` and `waypaper` are listed in `packages/aur.txt`. Install them with an AUR helper such as yay:

```bash
yay -S --needed swww waypaper
```

The Waypaper post-command runs Pywal to generate colors for Hyprland, Kitty and Waybar. Default palettes are copied to `~/.cache/wal` during setup so the desktop can start before the first wallpaper change.

## Notes

- Eww is skipped because its configuration files are empty placeholders.
- Existing NVIDIA drivers are intentionally left untouched.
- Review `packages/aur.txt` before installing AUR packages.
- Run the installer from the repository directory; do not run the old installer from an unrelated clone.