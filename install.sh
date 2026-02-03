#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Actualizando sistema"
sudo pacman -Syu --noconfirm

echo "==> Instalando paquetes pacman"
sudo pacman -S --needed --noconfirm $(grep -v '^#' "$DOTFILES/packages/pacman.txt")

echo "==> Instalando yay (si no existe)"
if ! command -v yay &>/dev/null; then
  sudo pacman -S --needed --noconfirm git base-devel
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

echo "==> Instalando paquetes AUR"
yay -S --needed --noconfirm $(grep -v '^#' "$DOTFILES/packages/aur.txt")

echo "==> Creando symlinks de ~/.config"
mkdir -p ~/.config

for dir in "$DOTFILES"/config/*; do
  name=$(basename "$dir")
  target="$HOME/.config/$name"

  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -s "$dir" "$target"
  echo "  -> $name"
done

echo "==> ZSH"
if [ -f "$DOTFILES/zsh/.zshrc" ]; then
  rm -f ~/.zshrc
  ln -s "$DOTFILES/zsh/.zshrc" ~/.zshrc
fi

echo "==> Detectando NVIDIA"
if lspci | grep -i nvidia &>/dev/null; then
  echo "NVIDIA detectada"
  sudo pacman -S --needed --noconfirm nvidia nvidia-utils nvidia-settings
fi

echo "==> Recargando servicios"
systemctl --user restart pipewire wireplumber || true

echo "==> DONE ✅ Reinicia sesión para aplicar todo"
