#!/bin/bash

# Stop on error
set -e

# Root-Passwort setzen
echo "Neues Root-Passwort setzen..."
passwd root

# Root-Login über SSH aktivieren
echo "Root-Login über SSH aktivieren..."
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH-Dienst neu starten
echo "SSH-Dienst wird neu gestartet..."
systemctl restart ssh

echo "Root-Login wurde aktiviert!"
