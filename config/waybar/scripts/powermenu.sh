#!/bin/bash
chosen=$(echo -e " Apagar\n Reiniciar\n Bloquear\n Salir de Hyprland" | rofi -dmenu -p "Acción:")

case "$chosen" in
  " Apagar")
    systemctl poweroff
    ;;
  " Reiniciar")
    systemctl reboot
    ;;
  " Bloquear")
    hyprlock 
    ;;
  " Salir de Hyprland")
    hyprctl dispatch exit
    ;;
esac
