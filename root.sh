#!/bin/bash

# Root-Passwort setzen
echo "Neues Root-Passwort setzen..."
sudo passwd root

# Root-Login über SSH aktivieren
echo "Root-Login über SSH aktivieren..."
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH-Dienst neu starten
echo "SSH-Dienst wird neu gestartet..."
sudo systemctl restart ssh

echo "Root-Login wurde aktiviert!"
