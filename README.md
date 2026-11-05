# dotfiles-2026

Arch Linux + Hyprland dotfiles, updated for Hyprland 0.57+ (Lua configuration). The installer preserves existing user configuration by moving conflicts into timestamped backups.

## Install

```bash
git clone --branch fix/arch-hyprland-installation --single-branch https://github.com/Bobe1destructor/dotfiles-2026.git ~/dotfiles-2026-fixed
cd ~/dotfiles-2026-fixed
chmod +x install.sh
./install.sh
```

The installer performs a full Arch package upgrade, installs the official dependencies listed in `packages/pacman.txt`, enables `power-profiles-daemon`, creates timestamped backups of conflicting `~/.config` entries and `~/.zshrc`, and creates symlinks to this repository. It does not replace NVIDIA drivers.

## Optional wallpaper integration (AUR)

Install an AUR helper such as yay if you do not already have one:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

Then run the installer again, or install the wallpaper packages directly:

```bash
yay -S --needed swww waypaper
```

Waypaper runs Pywal after changing the wallpaper. Pywal generates matching colors for Hyprland Lua, Kitty, Waybar and Cava.

## Notes

- Hyprland 0.57+ reads `config/hypr/hyprland.lua`; the old `.conf` file is retained only as a legacy reference.
- Wofi is the primary application launcher; Rofi remains available for the power menu.
- Eww is skipped because its configuration files are empty placeholders.
- Existing NVIDIA drivers are intentionally left untouched.