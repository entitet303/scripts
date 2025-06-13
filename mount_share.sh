#!/bin/bash

set -e

# Sicherstellen, dass das Skript als root läuft
if [ "$EUID" -ne 0 ]; then
    echo "Bitte als root ausführen (sudo)."
    exit 1
fi

# Benötigte Pakete installieren
apt update
apt install -y cifs-utils nfs-common

if [[ "$1" == "undo" ]]; then
    read -p "Mount-Punkt der entfernt werden soll: " MOUNT_POINT
    sed -i \"\\#$MOUNT_POINT#d\" /etc/fstab
    umount "$MOUNT_POINT" 2>/dev/null || true
    echo "Eintrag entfernt."
    exit 0
fi

read -p "Typ der Freigabe (smb/nfs): " TYPE
read -p "Freigabe-URL (z.B. //server/share oder 192.168.1.1:/path): " SHARE
read -p "Mount-Punkt (z.B. /mnt/share): " MOUNT_POINT

if [[ "$TYPE" == "smb" ]]; then
    read -p "Benutzername: " USERNAME
    read -s -p "Passwort: " PASSWORD
    echo
    CREDENTIALS_FILE="/root/.${MOUNT_POINT##*/}_cred"
    echo "username=$USERNAME" > "$CREDENTIALS_FILE"
    echo "password=$PASSWORD" >> "$CREDENTIALS_FILE"
    FSTAB_ENTRY="$SHARE $MOUNT_POINT cifs credentials=$CREDENTIALS_FILE,iocharset=utf8,file_mode=0777,dir_mode=0777,nofail 0 0"
elif [[ "$TYPE" == "nfs" ]]; then
    FSTAB_ENTRY="$SHARE $MOUNT_POINT nfs defaults,nofail 0 0"
else
    echo "Unbekannter Typ: $TYPE"
    exit 1
fi

mkdir -p "$MOUNT_POINT"
grep -qxF "$FSTAB_ENTRY" /etc/fstab || echo "$FSTAB_ENTRY" >> /etc/fstab
mount -a

echo "Freigabe wurde erfolgreich gemountet." 
