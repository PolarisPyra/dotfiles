#!/bin/bash
# Configurations
WALLPAPER_DIR="$HOME/.dotfiles/.config/hypr/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="1024" # 16:9 width
THUMBNAIL_HEIGHT="576" # 16:9 height
CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

# Ensure cache directory exists
ensure_cache_dir() {
    mkdir -p "$CACHE_DIR"
}

# Generate thumbnail for a wallpaper only if it doesn't exist or is outdated
generate_thumbnail_if_needed() {
    local input="$1"
    local output="$2"
    
    # Only generate if the thumbnail doesn't exist or the original is newer
    if [[ ! -f "$output" || "$input" -nt "$output" ]]; then
        magick "$input" \
            -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
            -gravity center \
            -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
            -quality 90 \
            "$output"
    fi
}

# Generate menu entries for wofi
generate_menu() {
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        [[ -f "$img" ]] || continue
        local base_name
        base_name="$(basename "${img%.*}")"
        local thumbnail="$CACHE_DIR/$base_name.png"
        
        # Generate thumbnail if needed
        generate_thumbnail_if_needed "$img" "$thumbnail"
        
        # Output for wofi
        echo -en "img:$thumbnail\x00info:$base_name\x1f$img\n"
    done
}

# Set the wallpaper using hyprpaper
set_wallpaper() {
    local wallpaper_path="$1"
    if [[ -f "$wallpaper_path" ]]; then
        hyprctl hyprpaper preload "$wallpaper_path"
        hyprctl hyprpaper wallpaper ",$wallpaper_path"
        echo "$wallpaper_path" > "$CURRENT_WALLPAPER_FILE"
    fi
}

# Handle wallpaper selection
handle_selection() {
    local selected="$1"
    if [[ -n "$selected" ]]; then
        local thumbnail_path="${selected#*img:}"
        local original_filename
        original_filename="$(basename "${thumbnail_path%.*}")"
        local wallpaper_path
        wallpaper_path="$(find "$WALLPAPER_DIR" -type f -iname "${original_filename}.*" | head -n 1)"
        [[ -n "$wallpaper_path" ]] && set_wallpaper "$wallpaper_path"
    fi
}

# Main function
main() {
    ensure_cache_dir
    
    local selected
    selected=$(generate_menu | wofi --show dmenu \
        --cache-file /dev/null \
        --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
        --columns 4 \
        --allow-images \
        --insensitive \
        --sort-order=default \
        --conf ~/.config/wofi/wallpaper.conf)
    
    handle_selection "$selected"
}

main 