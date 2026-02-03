#!/bin/bash
CURRENT=$(powerprofilesctl get)

if [ "$CURRENT" = "performance" ]; then
  powerprofilesctl set balanced
  notify-send "Perfil de energía" "Cambiado a Balanced"
elif [ "$CURRENT" = "balanced" ]; then
  powerprofilesctl set power-saver
  notify-send "Perfil de energía" "Cambiado a Power Saver"
else
  powerprofilesctl set performance
  notify-send "Perfil de energía" "Cambiado a Performance"
fi
