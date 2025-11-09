#!/usr/bin/env bash

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

readonly -a DEVELOPER=(
    "neovim"
    "zed"
    "git"
    "base-devel"
    "stow"
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
    echo ":: Installing yay..."

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

    echo ":: yay has been installed successfully."
    return 0
}

install_packages() {
    local category="$1"
    shift
    local pkg

    echo ""
    echo ":: Installing ${category} packages..."
    echo ""

    for pkg in "$@"; do
        if is_installed "${pkg}"; then
            echo ":: ${pkg} is already installed."
            continue
        fi

        echo ":: Installing ${pkg}..."
        if ! yay --noconfirm -S "${pkg}"; then
            echo ":: Failed to install ${pkg}" >&2
        fi
    done
}

install_packages() {
    local category="$1"
    shift
    local pkg

    echo ""
    echo ":: Installing ${category} packages..."
    echo ""

    for pkg in "$@"; do
        if is_installed "${pkg}"; then
            echo ":: ${pkg} is already installed."
            continue
        fi

        echo ":: Installing ${pkg}..."
        if ! yay --noconfirm -S "${pkg}"; then
            echo ":: Failed to install ${pkg}" >&2
        fi
    done
}

main() {
  echo ""
  echo " Welcome!"
  echo ""
    if ! command_exists "yay"; then
        echo ":: yay is not installed"
        if ! install_yay; then
            echo ":: Failed to install yay" >&2
            exit 1
        fi
    else
        echo ":: yay is already installed"
    fi

    install_packages "Developer" "${DEVELOPER[@]}"
    install_packages "Theming" "${THEMING[@]}"
    install_packages "Gaming" "${GAMING[@]}"
    install_packages "Apps" "${APPS[@]}"

    echo ""
    echo " Installation complete!"

}

main
