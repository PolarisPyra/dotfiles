#!/usr/bin/env bash
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly -a SYSTEM=(
    "neovim"
    "git"
    "visual-studio-code-bin"
    "base-devel"
    "stow"
    "nemo"
)
readonly -a THUMBNAIL=(
    "openscad-thumbnailers"
    "ffmpegthumbnailer"
    "webp-pixbuf-loader"
    "freetype2"
    "evince"
    "poppler-glib"
    "gnome-epub-thumbnailer"
    "libgsf"
    "f3d"
)
readonly -a THEMING=(
    "bibata-cursor-theme"
    "awww-git"
)
readonly -a GAMING=(
    "steam"
    "protonup-qt"
    "gamemode"
)
readonly -a APPS=(
    "ghostty"
    "helium-browser-bin"
    "vesktop"
)
is_installed() {
    local package="$1"
    local check
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [[ -n "${check}" ]]; then
        return 0
    fi
    return 1
}
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
install_yay() {
    local temp_path
    if ! is_installed "base-devel"; then
        sudo pacman --noconfirm -S "base-devel" || return 1
    fi
    if ! is_installed "git"; then
        sudo pacman --noconfirm -S "git" || return 1
    fi
    if [[ -d "${HOME}/Downloads/yay-bin" ]]; then
        rm -rf "${HOME}/Downloads/yay-bin"
    fi
    git clone https://aur.archlinux.org/yay-bin.git "${HOME}/Downloads/yay-bin" || return 1
    temp_path="${SCRIPT_DIR}"
    cd "${HOME}/Downloads/yay-bin" || return 1
    makepkg -si || return 1
    cd "${temp_path}" || return 1
    return 0
}
install_packages() {
    local pkg
    for pkg in "$@"; do
        if is_installed "${pkg}"; then
            continue
        fi
        yay --noconfirm -S "${pkg}"
    done
}
main() {
    local any_installed=false
    if ! command_exists "yay"; then
        if ! install_yay; then
            exit 1
        fi
        any_installed=true
    fi
    for pkg in "${SYSTEM[@]}" "${THUMBNAIL[@]}" "${THEMING[@]}" "${GAMING[@]}" "${APPS[@]}"; do
        if ! is_installed "${pkg}"; then
            any_installed=true
            break
        fi
    done
    install_packages "${SYSTEM[@]}"
    install_packages "${THUMBNAIL[@]}"
    install_packages "${THEMING[@]}"
    install_packages "${GAMING[@]}"
    install_packages "${APPS[@]}"
    if [[ "$any_installed" == false ]]; then
        echo: ""
        echo ":: All packages already installed"
        echo: ""
    else
        echo ""
        echo ":: Installation complete"
        echo ""
    fi
}
main
