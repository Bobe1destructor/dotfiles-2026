#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f /etc/arch-release ]]; then
    echo "Este instalador está preparado para Arch Linux y derivados."
    exit 1
fi

echo "==> Instalando dependencias oficiales"
mapfile -t PACMAN_PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$DOTFILES/packages/pacman.txt")
if (("${#PACMAN_PACKAGES[@]}" > 0)); then
    sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"
fi

echo
echo "==> AUR"
echo "No se instalará yay ni se ejecutará código AUR automáticamente."
echo "Los paquetes opcionales están documentados en packages/aur.txt."

echo
echo "==> Creando respaldos y enlaces de configuración"
bash "$DOTFILES/scripts/link.sh"

echo
echo "==> Permisos de scripts"
find "$DOTFILES/config/waybar/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} +

echo
echo "==> Comprobaciones"
for script in "$DOTFILES"/config/waybar/scripts/*.sh; do
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
