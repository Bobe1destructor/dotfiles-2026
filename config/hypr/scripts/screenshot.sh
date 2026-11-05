#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
directory="$HOME/Pictures/Screenshots"
mkdir -p "$directory"
file="$directory/$(date +'%Y-%m-%d_%H-%M-%S').png"

case "$mode" in
    full)
        grim "$file"
        notify-send "Captura" "Pantalla completa guardada"
        ;;
    region)
        geometry="$(slurp)" || exit 0
        [[ -n "$geometry" ]] || exit 0
        grim -g "$geometry" "$file"
        notify-send "Captura" "Región guardada"
        ;;
    window)
        geometry="$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
        [[ "$geometry" != "null" && -n "$geometry" ]] || exit 1
        grim -g "$geometry" "$file"
        notify-send "Captura" "Ventana guardada"
        ;;
    copy-full)
        grim - | wl-copy
        notify-send "Captura" "Pantalla copiada al portapapeles"
        ;;
    copy-region)
        geometry="$(slurp)" || exit 0
        [[ -n "$geometry" ]] || exit 0
        grim -g "$geometry" - | wl-copy
        notify-send "Captura" "Región copiada al portapapeles"
        ;;
    *)
        echo "Uso: $0 {full|region|window|copy-full|copy-region}" >&2
        exit 2
        ;;
esac
