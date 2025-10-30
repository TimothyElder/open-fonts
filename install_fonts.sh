#!/usr/bin/env bash
set -euo pipefail

# install-fonts.sh — cross-platform font installer for macOS and Debian-family Linux
# Usage:
#   ./install-fonts.sh [FONT_DIR] [--system] [--force]
#
#   FONT_DIR : directory with fonts (defaults to the script's directory)
#   --system : macOS only; install to /Library/Fonts (requires sudo)
#   --force  : overwrite existing files if present

# --- helpers ---
abort() { echo "Error: $*" >&2; exit 1; }
say()   { echo "• $*"; }

# --- resolve SOURCE directory (defaults to script dir) ---
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${1:-$SCRIPT_DIR}"

shift || true
SYSTEM_WIDE=false
FORCE=false
while (( "$#" )); do
  case "$1" in
    --system) SYSTEM_WIDE=true ;;
    --force)  FORCE=true ;;
    *) abort "Unknown option: $1" ;;
  esac
  shift
done

[[ -d "$SRC_DIR" ]] || abort "Source directory not found: $SRC_DIR"

# --- detect OS ---
OS="unknown"
if [[ "$OSTYPE" == darwin* ]]; then
  OS="macos"
elif [[ -f /etc/os-release ]]; then
  . /etc/os-release
  case "${ID_LIKE:-$ID}" in
    *debian*|*ubuntu*|*linuxmint*|*mx*|*raspbian*) OS="debian" ;;
  esac
fi
[[ "$OS" == "unknown" ]] && abort "Unsupported OS. Only macOS and Debian-family Linux are supported."

# --- destination path ---
if [[ "$OS" == "macos" ]]; then
  if $SYSTEM_WIDE; then
    DEST="/Library/Fonts"
  else
    DEST="$HOME/Library/Fonts"
  fi
else
  DEST="/usr/local/share/fonts"
fi

# --- ensure destination exists ---
if [[ ! -d "$DEST" ]]; then
  if [[ -w "$(dirname "$DEST")" ]]; then
    mkdir -p "$DEST"
  else
    say "Creating $DEST (sudo may be required)..."
    sudo mkdir -p "$DEST"
  fi
fi

# --- collect font files recursively ---
FILES=()
while IFS= read -r -d '' f; do
  FILES+=("$f")
done < <(find "$SRC_DIR" -type f \( \
  -iname '*.ttf' -o -iname '*.otf' -o -iname '*.ttc' -o -iname '*.otc' -o -iname '*.dfont' \
\) -print0)

if [ ${#FILES[@]} -eq 0 ]; then
  abort "No font files (.ttf/.otf/.ttc/.otc/.dfont) found in $SRC_DIR"
fi

say "Installing ${#FILES[@]} font file(s) to $DEST"
for f in "${FILES[@]}"; do
  tgt="$DEST/$(basename "$f")"
  if [[ -e "$tgt" && $FORCE == false ]]; then
    echo "  - Skipping (exists): $(basename "$f")  (use --force to overwrite)"
    continue
  fi
  if [[ -w "$DEST" ]]; then
    install -m 0644 "$f" "$DEST/"
  else
    sudo install -m 0644 "$f" "$DEST/"
  fi
  echo "  - Installed: $(basename "$f")"
done

# --- refresh cache on Linux ---
if [[ "$OS" == "debian" ]]; then
  say "Refreshing font cache..."
  if command -v fc-cache >/dev/null 2>&1; then
    if [[ -w "$DEST" ]]; then
      fc-cache -f >/dev/null
    else
      sudo fc-cache -f >/dev/null
    fi
  else
    echo "  - Note: 'fc-cache' not found; install 'fontconfig' to refresh cache automatically."
  fi
fi

say "Done. Fonts installed to: $DEST"
if [[ "$OS" == "macos" ]]; then
  echo "  - macOS: Most apps pick up fonts immediately; some may require restart."
else
  echo "  - Linux: If fonts don't appear, log out/in or restart the application."
fi