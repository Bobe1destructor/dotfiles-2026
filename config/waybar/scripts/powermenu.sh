#!/usr/bin/env bash
set -u

options=$' Apagar\n Reiniciar\n Bloquear\n Salir de Hyprland'

if command -v rofi >/dev/null 2>&1; then
    chosen="$(printf '%s\n' "$options" | rofi -dmenu -i -p "Acción:")" || exit 0
elif command -v wofi >/dev/null 2>&1; then
    chosen="$(printf '%s\n' "$options" | wofi --dmenu --prompt "Acción:")" || exit 0
else
    command -v notify-send >/dev/null 2>&1 && notify-send "Menú de energía" "Instala rofi o wofi"
    exit 1
fi

case "$chosen" in
    " Apagar") systemctl poweroff ;;
    " Reiniciar") systemctl reboot ;;
    " Bloquear")
        if command -v hyprlock >/dev/null 2>&1; then hyprlock
        else notify-send "Menú de energía" "hyprlock no está instalado"; exit 1
        fi
        ;;
    " Salir de Hyprland") hyprctl dispatch exit ;;
    *) exit 0 ;;
esac
