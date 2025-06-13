#!/bin/bash

# NVIDIA Treiber Installationsscript für Debian CT unter Proxmox VE
# Getestet mit NVIDIA RTX 2060 GPU
# Muss in einem privilegierten Container mit GPU Passthrough ausgeführt werden

set -e

if [[ "$1" == "undo" ]]; then
    echo "Entferne NVIDIA Treiber..."
    apt purge -y nvidia-driver || true
    apt autoremove -y
    if [ -f /etc/apt/sources.list.bak ]; then
        mv /etc/apt/sources.list.bak /etc/apt/sources.list
    else
        sed -i 's/ contrib non-free//' /etc/apt/sources.list
    fi
    apt update
    echo "NVIDIA Treiber wurden entfernt."
    exit 0
fi

# Prüfen, ob das Skript als root ausgeführt wird
if [ "$EUID" -ne 0 ]; then
    echo "Bitte als root ausführen (sudo)."
    exit 1
fi

echo "Aktualisiere Paketlisten..."
apt update

# Non-free Repository hinzufügen, falls noch nicht vorhanden
if ! grep -E 'non-free' /etc/apt/sources.list > /dev/null; then
    echo "Füge non-free Repository hinzu..."
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sed -i '/^deb .* main/ s/$/ contrib non-free/' /etc/apt/sources.list
fi

apt update

echo "Installiere benötigte Pakete..."
apt install -y build-essential dkms linux-headers-$(uname -r) pciutils

echo "Installiere NVIDIA Treiber..."
apt install -y nvidia-driver

echo "Treiberinstallation abgeschlossen."
echo "Es wird empfohlen, den Container neu zu starten."
