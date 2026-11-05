#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f /etc/arch-release ]]; then
    echo "Este instalador está preparado para Arch Linux y derivados."
    exit 1
fi

echo "==> Instalando dependencias oficiales (actualización completa de Arch)"
mapfile -t PACMAN_PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$DOTFILES/packages/pacman.txt")
if (("${#PACMAN_PACKAGES[@]}" > 0)); then
    sudo pacman -Syu --needed "${PACMAN_PACKAGES[@]}"
fi

if pacman -Q power-profiles-daemon >/dev/null 2>&1; then
    sudo systemctl enable --now power-profiles-daemon.service
fi

echo
echo "==> AUR"
echo "No se instalará yay ni se ejecutará código AUR automáticamente."
if command -v yay >/dev/null 2>&1; then
    mapfile -t AUR_PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$DOTFILES/packages/aur.txt")
    if (("${#AUR_PACKAGES[@]}" > 0)); then yay -S --needed "${AUR_PACKAGES[@]}"; fi
else
    echo "yay no está instalado. Instala swww y waypaper desde AUR para habilitar los fondos dinámicos."
fi

echo
echo "==> Creando respaldos y enlaces de configuración"
bash "$DOTFILES/scripts/link.sh"

echo
echo "==> Preparando paletas de color de respaldo"
mkdir -p "$HOME/.cache/wal" "$HOME/Pictures/Screenshots"
[[ -s "$HOME/.cache/wal/colors-hyprland.lua" ]] || cp "$DOTFILES/config/wal/defaults/colors-hyprland.lua" "$HOME/.cache/wal/colors-hyprland.lua"
[[ -s "$HOME/.cache/wal/colors-waybar.css" ]] || cp "$DOTFILES/config/wal/defaults/colors-waybar.css" "$HOME/.cache/wal/colors-waybar.css"
[[ -s "$HOME/.cache/wal/colors-kitty.conf" ]] || cp "$DOTFILES/config/wal/defaults/colors-kitty.conf" "$HOME/.cache/wal/colors-kitty.conf"
ln -sfn "$HOME/.cache/wal/colors-waybar.css" "$DOTFILES/config/waybar/colors-waybar.css"
mkdir -p "$HOME/.config/cava/themes"
[[ -s "$HOME/.config/cava/themes/wal" ]] || cp "$DOTFILES/config/wal/defaults/cava" "$HOME/.config/cava/themes/wal"

echo
echo "==> Permisos de scripts"
find "$DOTFILES/config/waybar/scripts" "$DOTFILES/config/hypr/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} +
chmod +x "$DOTFILES/config/waypaper/swww_wal.sh"

echo
echo "==> Comprobaciones"
for script in "$DOTFILES"/config/waybar/scripts/*.sh "$DOTFILES"/config/hypr/scripts/*.sh "$DOTFILES/config/waypaper/swww_wal.sh"; do
    bash -n "$script"
done

echo
echo "==> GPU"
if lspci | grep -qi 'NVIDIA'; then
    echo "NVIDIA detectada. No se modificarán los controladores instalados."
fi

echo
echo "Instalación base terminada."
echo "Reinicia Hyprland o cierra y vuelve a iniciar sesión."
