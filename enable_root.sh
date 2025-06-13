#!/bin/bash

set -e

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Bitte als root ausführen (sudo)."
    exit 1
fi

if [[ "$1" == "undo" ]]; then
    echo "Root-Login wird deaktiviert..."
    if [ -f /etc/ssh/sshd_config.bak ]; then
        mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    else
        sed -i 's/^PermitRootLogin yes/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    fi
    systemctl restart ssh
    echo "Root-Login wurde deaktiviert."
    exit 0
fi

echo "Neues Root-Passwort setzen..."
passwd root

if [ ! -f /etc/ssh/sshd_config.bak ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
fi

echo "Root-Login über SSH aktivieren..."
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

echo "SSH-Dienst wird neu gestartet..."
systemctl restart ssh

echo "Root-Login wurde aktiviert!"
