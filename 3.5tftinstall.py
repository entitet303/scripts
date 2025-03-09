#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing required packages..."
sudo apt install -y python3-pip python3-pygame python3-requests python3-spotipy \
                    git xserver-xorg xinit x11-xserver-utils matchbox-keyboard

# Touchscreen Treiber installieren
echo "Installing touchscreen driver..."
if [ ! -d "LCD-show" ]; then
    git clone https://github.com/goodtft/LCD-show.git
fi
cd LCD-show
chmod +x LCD35-show
./LCD35-show

# Spotify Touchscreen GUI installieren
echo "Installing Spotify Touchscreen GUI..."
cd ~
if [ ! -d "spotify-touch" ]; then
    git clone https://github.com/deinrepo/spotify-touch.git
fi
cd spotify-touch
pip3 install -r requirements.txt

# Autostart einrichten
echo "Setting up autostart..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/spotify-touch.desktop
[Desktop Entry]
Type=Application
Exec=python3 ~/spotify-touch/spotify_touch.py
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Spotify Touch GUI
EOF

# Neustart erforderlich
echo "Installation complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
