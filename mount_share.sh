#!/bin/bash

# Benutzer-Eingaben
read -p "Geben Sie die CIFS-Freigabe ein (z.B. //192.168.2.50/jellyfin): " SHARE
read -p "Geben Sie den Mount-Punkt ein (z.B. /data): " MOUNT_POINT
read -p "Geben Sie den Benutzernamen ein: " USERNAME
read -s -p "Geben Sie das Passwort ein: " PASSWORD
echo ""

# Pakete installieren
apt update && apt install -y cifs-utils

# Anmeldeinformationen speichern
CREDENTIALS_FILE="/root/.cifs_credentials"
echo "username=$USERNAME" > $CREDENTIALS_FILE
echo "password=$PASSWORD" >> $CREDENTIALS_FILE
chmod 600 $CREDENTIALS_FILE

# Mount-Punkt erstellen
mkdir -p $MOUNT_POINT

# fstab-Eintrag hinzufügen
FSTAB_ENTRY="$SHARE $MOUNT_POINT cifs credentials=$CREDENTIALS_FILE,iocharset=utf8,file_mode=0777,dir_mode=0777,nofail 0 0"
grep -qxF "$FSTAB_ENTRY" /etc/fstab || echo "$FSTAB_ENTRY" >> /etc/fstab

# Mount ausführen
mount -a

echo "CIFS-Freigabe wurde erfolgreich gemountet!"
