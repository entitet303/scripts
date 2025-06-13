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

