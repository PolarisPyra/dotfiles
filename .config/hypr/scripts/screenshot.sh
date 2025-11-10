#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

SELECTION=$(printf "Window\nRegion\nMonitor" | fuzzel --dmenu --lines 3)

case "$SELECTION" in
    "Window")
        hyprshot -m window -o "$SCREENSHOT_DIR"
        ;;
    "Region")
        hyprshot -m region -o "$SCREENSHOT_DIR"
        ;;
    "Monitor")
        hyprshot -m output -o "$SCREENSHOT_DIR"
        ;;
esac
