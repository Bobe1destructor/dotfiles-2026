#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
CONFIG="$DOTFILES/config"

echo "🔗 Creando symlinks..."

mkdir -p ~/.config

for dir in dunst eww hypr kitty nvim ranger rofi wal waybar waypaper wofi; do
  if [ -e "$HOME/.config/$dir" ] || [ -L "$HOME/.config/$dir" ]; then
    echo "♻️  Reemplazando $dir"
    rm -rf "$HOME/.config/$dir"
  fi
  ln -s "$CONFIG/$dir" "$HOME/.config/$dir"
done

# zsh
if [ -e "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo "✅ Symlinks listos"
