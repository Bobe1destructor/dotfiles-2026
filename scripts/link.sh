#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$DOTFILES/config"
BACKUP_ROOT="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$HOME/.config"
linked=0

for source in "$CONFIG"/*; do
    [[ -d "$source" ]] || continue
    name="$(basename "$source")"
    target="$HOME/.config/$name"

    # Do not link empty placeholder configurations.
    if [[ "$name" == "eww" ]] && [[ ! -s "$source/eww.yuck" || ! -s "$source/eww.scss" ]]; then
        echo "[SKIP] eww: configuración vacía"
        continue
    fi

    if [[ -L "$target" ]]; then
        current="$(readlink -f "$target" || true)"
        if [[ "$current" == "$source" ]]; then
            echo "[OK] $name ya está enlazado"
            continue
        fi
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_ROOT"
        mv -- "$target" "$BACKUP_ROOT/$name"
        echo "[BACKUP] $target -> $BACKUP_ROOT/$name"
    fi

    ln -s -- "$source" "$target"
    echo "[LINK] $name"
    linked=$((linked + 1))
done

if [[ -f "$DOTFILES/zsh/.zshrc" ]]; then
    if [[ -L "$HOME/.zshrc" ]] && [[ "$(readlink -f "$HOME/.zshrc" || true)" == "$DOTFILES/zsh/.zshrc" ]]; then
        echo "[OK] .zshrc ya está enlazado"
    else
        if [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
            mkdir -p "$BACKUP_ROOT"
            mv -- "$HOME/.zshrc" "$BACKUP_ROOT/.zshrc"
            echo "[BACKUP] ~/.zshrc -> $BACKUP_ROOT/.zshrc"
        fi
        ln -s -- "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
        echo "[LINK] .zshrc"
    fi
fi

echo "Enlaces creados: $linked"
[[ -d "$BACKUP_ROOT" ]] && echo "Respaldos: $BACKUP_ROOT"
