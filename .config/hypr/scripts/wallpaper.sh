#!/usr/bin/env bash

r variable
wall_dir="$HOME/Documents/wallpapers"

# Get focused monitor
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Check if fuzzel is already running
if pidof fuzzel > /dev/null; then
  pkill fuzzel
fi

# Launch fuzzel with wallpaper list
wall_selection=$(find "${wall_dir}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) -print0 | \
    xargs -0 basename -a | \
    LC_ALL=C sort -V | \
    fuzzel --dmenu --prompt "Wallpaper: " --width 40 --lines 10)

# SWWW Config
FPS=120
TYPE="any"
DURATION=2
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# full wallpaper path
wallpaper_path="${wall_dir}/${wall_selection}"

# set wallpaper
if [[ -n "$wall_selection" ]]; then
	# set wallpaper for all monitors
	swww img "${wallpaper_path}" $SWWW_PARAMS

	# copy the wallpaper in current-wallpaper file
	mkdir -p "$HOME/.local/share"
	ln -sf "$wallpaper_path" "$HOME/.local/share/bg"

	# send notification after completion
	notify-send "Wallpaper changed successfully" -i "$HOME/.local/share/bg"
fi

