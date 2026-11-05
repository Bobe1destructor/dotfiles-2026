#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="${1:-}"
if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    echo "Uso: $0 /ruta/al/fondo" >&2
    exit 2
fi

if ! command -v wal >/dev/null 2>&1; then
    command -v notify-send >/dev/null 2>&1 && notify-send "Pywal" "Instala python-pywal para generar los colores" || true
    exit 1
fi

# Waypaper/swww ya aplica el fondo. Pywal solo genera la paleta.
wal -n -i "$WALLPAPER"

# Aplicar el tema de Cava generado por la plantilla de Pywal.
if [[ -s "$HOME/.cache/wal/cava" ]]; then
    mkdir -p "$HOME/.config/cava/themes"
    cp "$HOME/.cache/wal/cava" "$HOME/.config/cava/themes/wal"
    pkill -USR1 cava 2>/dev/null || true
fi

# Aplicar colores nuevos sin cerrar la sesión.
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
fi

# Waybar lee los colores desde ~/.cache/wal mediante una ruta CSS relativa.
pkill -SIGUSR2 waybar 2>/dev/null || true
