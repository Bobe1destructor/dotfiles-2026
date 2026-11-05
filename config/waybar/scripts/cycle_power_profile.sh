#!/usr/bin/env bash
set -euo pipefail

notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send -a "Power profile" "$1" "$2" || true
}

if ! command -v powerprofilesctl >/dev/null 2>&1; then
    notify "Perfil de energía" "No se encontró powerprofilesctl"
    exit 1
fi

current="$(powerprofilesctl get)"
case "$current" in
    performance) next="balanced"; label="Equilibrado" ;;
    balanced) next="power-saver"; label="Ahorro de energía" ;;
    power-saver) next="performance"; label="Máximo rendimiento" ;;
    *) notify "Perfil de energía" "Perfil desconocido: $current"; exit 1 ;;
esac

if powerprofilesctl set "$next"; then
    notify "Perfil de energía" "Cambiado a $label"
else
    notify "Perfil de energía" "No se pudo cambiar a $label"
    exit 1
fi
