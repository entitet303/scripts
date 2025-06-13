#!/bin/bash

# LCD display driver installation script for 3.5inch RPi Display
# Based on LCD-show driver from http://www.lcdwiki.com/3.5inch_RPi_Display

# Exit on error
set -e

if [[ "$1" == "undo" ]]; then
    echo "Stelle urspr\xC3\xBCngliche Displayeinstellungen wieder her..."
    if [ -d LCD-show ]; then
        (cd LCD-show && ./LCD-hdmi)
    fi
    [ -f /boot/config.txt.bak ] && mv /boot/config.txt.bak /boot/config.txt
    [ -f /etc/X11/xorg.conf.d/99-calibration.conf.bak ] && mv /etc/X11/xorg.conf.d/99-calibration.conf.bak /etc/X11/xorg.conf.d/99-calibration.conf
    echo "Displaytreiber entfernt."
    exit 0
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Install required packages
apt-get update
apt-get install -y cmake
apt-get install -y xserver-xorg-input-evdev

# Download LCD driver
wget http://www.lcdwiki.com/res/RPi_35_LCD_show.tar.gz
tar xzvf RPi_35_LCD_show.tar.gz
cd LCD-show/

# Install touchscreen calibration tool
apt-get install -y xinput-calibrator

# Backup original config files
if [ ! -f /boot/config.txt.bak ]; then
    cp /boot/config.txt /boot/config.txt.bak
fi
if [ -f /etc/X11/xorg.conf.d/99-calibration.conf ] && [ ! -f /etc/X11/xorg.conf.d/99-calibration.conf.bak ]; then
    cp /etc/X11/xorg.conf.d/99-calibration.conf /etc/X11/xorg.conf.d/99-calibration.conf.bak
fi

# Install LCD driver
./LCD35-show

echo "Installation complete. System will reboot now."
sleep 3
reboot
