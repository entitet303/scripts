#!/bin/bash
set -e

TARGET_DIR="/data/musik/spotify"
SPOTIFY_PLAYLIST_URL="https://open.spotify.com/playlist/66XWH87z74Mf9I18bBtMlK?si=4eece16fd3dd4644"

echo "System wird aktualisiert und Abhängigkeiten installiert..."
apt update
apt install -y python3 python3-pip ffmpeg curl

echo "spotdl wird installiert..."
pip3 install --upgrade spotdl

echo "Zielordner wird erstellt: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

echo "Playlist wird heruntergeladen..."
spotdl "$SPOTIFY_PLAYLIST_URL" --output "$TARGET_DIR"

echo "Fertig."
