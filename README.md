# scripts

Collection of shell scripts for system setup on Debian-based systems.

These steps assume you are running inside a **privileged Debian container** on Proxmox VE.

## Getting Started

1. Clone or download this repository inside your container.
2. Change into the repository directory:
   ```bash
   cd scripts
   ```

## Tutorial

### 1. Enable root login

1. Make the script executable:
   ```bash
   chmod +x enable_root.sh
   ```
2. Run the script with root privileges to set the root password and allow root SSH login:
   ```bash
   sudo ./enable_root.sh
   ```

### 2. Install NVIDIA drivers for an RTX 2060

1. Make sure GPU passthrough is configured for your container.
2. Make the driver script executable:
   ```bash
   chmod +x install_nvidia_rtx2060.sh
   ```
3. Execute the script as root to install the required packages and drivers:
   ```bash
   sudo ./install_nvidia_rtx2060.sh
   ```
4. Reboot the container after installation.

### 3. Install 3.5" TFT display drivers

1. Give the script permission to run:
   ```bash
   chmod +x 3.5TFT.sh
   ```
2. Execute it as root to install the LCD drivers and reboot:
   ```bash
   sudo ./3.5TFT.sh
   ```

### 4. Configure the Raspberry Pi as an access point

1. Make the script executable:
   ```bash
   chmod +x piap.sh
   ```
2. Run the script as root. It installs required packages, configures `hostapd` and `dnsmasq`, then reboots:
   ```bash
   sudo ./piap.sh
   ```

### 5. Mount a CIFS share

1. Make the script executable:
   ```bash
   chmod +x smb.sh
   ```
2. Run it as root and provide the share information when prompted:
   ```bash
   sudo ./smb.sh
   ```

### 6. Launch the system monitor

1. Install Python dependencies:
   ```bash
   sudo apt-get install -y python3-pygame python3-psutil
   ```
2. Start the monitor using Python:
   ```bash
   python3 monitor.py
   ```
