# scripts

Collection of shell scripts for system setup on Debian-based systems.

These steps assume you are running inside a **privileged Debian container** on Proxmox VE.

## Getting Started

The scripts can be run directly from the web without cloning the repository. Download a script with `wget` and execute it:

```bash
wget https://raw.githubusercontent.com/entitet303/scripts/main/<SCRIPT> -O <SCRIPT>
chmod +x <SCRIPT>
sudo ./<SCRIPT>
```

Replace `<SCRIPT>` with the name of the script you wish to run, e.g. `enable_root.sh`.

Alternatively you can clone the whole repository:

1. Clone this repository inside your container.
2. Change into the repository directory:
   ```bash
   cd scripts
   ```

## Tutorial

### 1. Enable root login

1. Download the script and make it executable:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/enable_root.sh -O enable_root.sh
   chmod +x enable_root.sh
   ```
2. Run the script with root privileges to set the root password and allow root SSH login:
   ```bash
   sudo ./enable_root.sh
   ```

### 2. Install NVIDIA drivers for an RTX 2060

1. Make sure GPU passthrough is configured for your container.
2. Download the driver script and make it executable:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/install_nvidia_rtx2060.sh -O install_nvidia_rtx2060.sh
   chmod +x install_nvidia_rtx2060.sh
   ```
3. Execute the script as root to install the required packages and drivers:
   ```bash
   sudo ./install_nvidia_rtx2060.sh
   ```
4. Reboot the container after installation.

### 3. Install 3.5" TFT display drivers

1. Download the script and make it executable:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/3.5TFT.sh -O 3.5TFT.sh
   chmod +x 3.5TFT.sh
   ```
2. Execute it as root to install the LCD drivers and reboot:
   ```bash
   sudo ./3.5TFT.sh
   ```

### 4. Configure the Raspberry Pi as an access point

1. Download the script and make it executable:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/piap.sh -O piap.sh
   chmod +x piap.sh
   ```
2. Run the script as root. It installs required packages, configures `hostapd` and `dnsmasq`, then reboots:
   ```bash
   sudo ./piap.sh
   ```

### 5. Mount a CIFS share

1. Download the script and make it executable:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/smb.sh -O smb.sh
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
2. Download the script and start the monitor:
   ```bash
   wget https://raw.githubusercontent.com/entitet303/scripts/main/monitor.py -O monitor.py
   python3 monitor.py
   ```
