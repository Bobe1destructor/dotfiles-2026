#!/bin/bash

$PLAYERCTL_PATH="/usr/bin/playerctl" 

$PLAYERCTL_PATH status 2>/dev/null | grep -E '(Playing|Paused)'
