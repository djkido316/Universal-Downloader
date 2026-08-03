# Universal Downloader

A lightweight Bash script for Linux that automatically detects the type of URL you provide and performs the appropriate action.

## Features

* ✅ Install Flatpak applications directly from Flathub pages
* ✅ Download YouTube videos using `yt-dlp`
* ✅ Clone GitHub repositories
* ✅ Download magnet links and `.torrent` files with `aria2`
* ✅ Download generic files with `wget`
* ✅ Automatically reads URLs from the clipboard if no argument is supplied
* ✅ Supports both Wayland and X11 clipboards

## Supported URLs

* 📦 Flathub
* 🎥 YouTube
* 📷 Instagram
* 🐙 GitHub
* 🧲 Magnet links
* 📄 `.torrent` files
* 🌐 Direct Links

## Dependencies

Required:

* `bash`
* `wget`

Optional (depending on what you use):

* `flatpak`
* `yt-dlp`
* `git`
* `aria2`
* `wl-clipboard` (Wayland)
* `xclip` or `xsel` (X11)

## Usage

Download from a URL:

```bash
./download.sh <URL>
```

### Examples

```bash
./download.sh https://flathub.org/apps/io.mpv.Mpv

./download.sh https://youtu.be/dQw4w9WgXcQ

./download.sh https://github.com/djkido316/DraculaBox

./download.sh "magnet:?xt=urn:btih:..."
```

Or simply run:

```bash
./download.sh
```

If no URL is supplied, the script will attempt to read one from your clipboard.

## License

MIT
