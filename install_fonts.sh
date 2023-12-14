#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Directory containing the font files is the same as the script's directory
FONT_DIR="$SCRIPT_DIR"

# Destination directory for the fonts
DEST_DIR="$HOME/Library/Fonts"

# Destination directory for the fonts
DEST_DIR="$HOME/Library/Fonts"

# Check if the font directory exists
if [ -d "$FONT_DIR" ]; then
    # Copy all .ttf and .ttc files to the user's font directory
    cp "$FONT_DIR"/*.ttf "$DEST_DIR"
    cp "$FONT_DIR"/*.ttc "$DEST_DIR"
    echo "Fonts have been installed."
else
    echo "The specified font directory does not exist."
fi