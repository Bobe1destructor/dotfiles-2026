#!/usr/bin/env bash
# Return success only while a MPRIS player is playing or paused.
set -u

if ! command -v playerctl >/dev/null 2>&1; then
    exit 1
fi

status="$(playerctl status 2>/dev/null || true)"
case "$status" in
    Playing|Paused) exit 0 ;;
    *) exit 1 ;;
esac
