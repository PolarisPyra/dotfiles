#!/bin/bash

# Configurations
WALLPAPER_DIR="$HOME/.dotfiles/.config/hypr/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="1024" # 16:9 width
THUMBNAIL_HEIGHT="576" # 16:9 height
CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

# Ensure clean cache each run
cleanup_cache() {
	rm -rf "$CACHE_DIR"
	mkdir -p "$CACHE_DIR"
}

# Generate thumbnail for a wallpaper
generate_thumbnail() {
	local input="$1"
	local output="$2"

	magick "$input" \
		-thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
		-gravity center \
		-extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
		-quality 90 \
		"$output"
}

# Generate menu entries for wofi
generate_menu() {
	for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
		[[ -f "$img" ]] || continue

		local base_name
		base_name="$(basename "${img%.*}")"
		local thumbnail="$CACHE_DIR/$base_name.png"

		generate_thumbnail "$img" "$thumbnail"
		echo -en "img:$thumbnail\x00info:$base_name\x1f$img\n"
	done
}

# Set the wallpaper using hyprpaper
set_wallpaper() {
	local wallpaper_path="$1"

	if [[ -f "$wallpaper_path" ]]; then
		hyprctl hyprpaper preload "$wallpaper_path"
		hyprctl hyprpaper wallpaper ",$wallpaper_path"
		echo "$wallpaper_path" >"$CURRENT_WALLPAPER_FILE"
	fi
}

# Handle wallpaper selection
handle_selection() {
	local selected="$1"

	if [[ -n "$selected" ]]; then
		local thumbnail_path="${selected#img:}"
		local original_filename
		original_filename="$(basename "${thumbnail_path%.*}")"

		local wallpaper_path
		wallpaper_path="$(find "$WALLPAPER_DIR" -type f -iname "${original_filename}.*" | head -n 1)"

		[[ -n "$wallpaper_path" ]] && set_wallpaper "$wallpaper_path"
	fi
}

# Main function
main() {
	cleanup_cache

	local selected
	selected=$(
		generate_menu | wofi --show dmenu \
			--cache-file /dev/null \
			--define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
			--columns 2 \
			--allow-images \
			--insensitive \
			--sort-order=default \
			--conf ~/.config/wofi/wallpaper_selector/wallpaper.conf
	)

	handle_selection "$selected"
}

main
