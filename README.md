# dotfiles-2026

Arch Linux + Hyprland dotfiles. The installer is designed to preserve existing user configuration.

## Install

```bash
git clone --branch fix/arch-hyprland-installation --single-branch https://github.com/Bobe1destructor/dotfiles-2026.git ~/dotfiles-2026-fixed
cd ~/dotfiles-2026-fixed
chmod +x install.sh
./install.sh
```

The installer performs a full Arch package upgrade, installs packages listed in `packages/pacman.txt`, creates timestamped backups of conflicting `~/.config` entries and `~/.zshrc`, and creates symlinks to this repository. It does not replace NVIDIA drivers or install an AUR helper.

## Optional wallpaper integration (AUR)

Install yay if you do not already have an AUR helper:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

Then install the wallpaper packages:

```bash
yay -S --needed swww waypaper
```

The Waypaper post-command runs Pywal to generate colors for Hyprland, Kitty, Waybar and Cava. Default palettes are copied to `~/.cache/wal` during setup so the desktop can start before the first wallpaper change.

## Notes

- Eww is skipped because its configuration files are empty placeholders.
- Existing NVIDIA drivers are intentionally left untouched.
- Review `packages/aur.txt` before installing AUR packages.