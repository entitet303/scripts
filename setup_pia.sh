#!/bin/bash

# Stoppe bei Fehler
set -e

# Variablen
PIA_USER="p5786431"
PIA_PASS="Fent96308642."
VPN_COUNTRY="turkey"
VPN_CONF_DIR="/etc/openvpn"
VPN_AUTH_FILE="$VPN_CONF_DIR/pia_auth.txt"
VPN_CONF_FILE="$VPN_CONF_DIR/pia.conf"

# OpenVPN installieren
echo "[*] Installiere OpenVPN und curl..."
apt update
apt install -y openvpn curl unzip

# Auth-Datei anlegen
echo "[*] Erstelle Auth-Datei..."
echo -e "$PIA_USER\n$PIA_PASS" > "$VPN_AUTH_FILE"
chmod 600 "$VPN_AUTH_FILE"

# Konfigurationsdateien holen
echo "[*] Lade Konfigurationsdateien von PIA..."
TMP_DIR=$(mktemp -d)
curl -s -o "$TMP_DIR/openvpn.zip" "https://www.privateinternetaccess.com/openvpn/openvpn.zip"
unzip -o "$TMP_DIR/openvpn.zip" -d "$TMP_DIR"

# Passende .ovpn-Datei für Turkey suchen
CONF_FILE_SRC=$(find "$TMP_DIR" -iname "*${VPN_COUNTRY}*.ovpn" | head -n1)
if [[ -z "$CONF_FILE_SRC" ]]; then
    echo "[!] Keine Konfigurationsdatei für '$VPN_COUNTRY' gefunden."
    exit 1
fi

echo "[*] Verwende Konfigurationsdatei: $CONF_FILE_SRC"
cp "$CONF_FILE_SRC" "$VPN_CONF_FILE"

# Konfiguration anpassen (auth-user-pass einfügen)
echo "[*] Passe Konfiguration an..."
sed -i "s|auth-user-pass|auth-user-pass $VPN_AUTH_FILE|" "$VPN_CONF_FILE"

# systemd Service aktivieren
SERVICE_NAME="openvpn@pia"
echo "[*] Aktiviere systemd Service: $SERVICE_NAME"
systemctl enable "openvpn@pia"
systemctl restart "openvpn@pia"

# Verbindung prüfen
sleep 5
if systemctl is-active --quiet "openvpn@pia"; then
    echo "[✔] OpenVPN wurde erfolgreich gestartet und ist aktiv."
else
    echo "[!] OpenVPN konnte nicht gestartet werden. Prüfe Logs mit: journalctl -u openvpn@pia"
    exit 1
fi
