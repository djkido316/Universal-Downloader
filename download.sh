#!/usr/bin/env bash

# Created: 03/26/2022
# Updated: 08/04/2026
# Distro: Arch Linux
# Author: djkido316
# Description: Universal downloader (YouTube, Flathub, GitHub, Torrents, Direct Links)
# Works with Wayland and X11 clipboards

set -euo pipefail

echo " ██████╗ ██████╗██╗    █████╗   ████╗     ██████╗ █████╗██████╗█████████████╗ " 
echo " ██╔══████╔═══████║    ██████╗  ████║    ██╔═══████╔══████╔══████╔════██╔══██╗" 
echo " ██║  ████║   ████║ █╗ ████╔██╗ ████║    ██║   ███████████║  ███████╗ ██████╔╝" 
echo " ██║  ████║   ████║███╗████║╚██╗████║    ██║   ████╔══████║  ████╔══╝ ██╔══██╗" 
echo " ██████╔╚██████╔╚███╔███╔██║ ╚███████████╚██████╔██║  ████████╔█████████║  ██║" 
echo " ╚═════╝ ╚═════╝ ╚══╝╚══╝╚═╝  ╚═══╚══════╝╚═════╝╚═╝  ╚═╚═════╝╚══════╚═╝  ╚═╝" 


mkdir -p "$HOME/Downloads/torrents" "$HOME/youtube" "$HOME/github"

get_clipboard() {
    if command -v wl-paste >/dev/null 2>&1; then wl-paste
    elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard -o
    elif command -v xsel >/dev/null 2>&1; then xsel --clipboard --output
    else return 1; fi
}

install_flatpak() {
    local URL="$1"
    [[ "$URL" == flatpak+* ]] && URL="${URL#flatpak+}"

    if [[ "$URL" =~ ^https://flathub\.org/.*/apps/([^/?#]+)$ ]]; then
        APP_ID="${BASH_REMATCH[1]}"
        URL="https://dl.flathub.org/repo/appstream/${APP_ID}.flatpakref"
    fi

    APP_NAME=$(basename "$URL" | sed 's/\.flatpakref$//')

    echo "Installing: $APP_NAME"
    echo "Source: $URL"

    echo "Attempting system installation..."
    if flatpak install --system --from "$URL"; then
    echo "✅ System installation completed."
    return
    fi

    echo "System install failed, trying user install..."
    flatpak install --user --from "$URL"
}

download_url() {
    local URL="$1"

    [[ "$URL" == flatpak+* ]] && install_flatpak "$URL" && return

    if [[ "$URL" =~ ^https://flathub\.org/.*/apps/ ]]; then
        install_flatpak "$URL"
        return
    fi

    case "$URL" in
        *youtube.com/*|*youtu.be/*)
            yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" \
                -P "$HOME/youtube" "$URL"
            ;;
        *github.com/*)
            cd "$HOME/github"
            git clone "$URL"
            ;;
        magnet:*)
            aria2c -d "$HOME/Downloads/torrents" --seed-time=0 "$URL"
            ;;
        *.torrent)
            aria2c -d "$HOME/Downloads/torrents" "$URL"
            ;;
        *)
            wget -P "$HOME/Downloads" "$URL"
            ;;
    esac
}

URL="${1:-}"
if [[ -z "$URL" ]]; then
    URL="$(get_clipboard || true)"
fi

[[ -z "$URL" ]] && { echo "Usage: $0 <URL> (or copy one to clipboard)"; exit 1; }

download_url "$URL"
