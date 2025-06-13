# scripts

Sample shell scripts used for system setup.

## Root Login

Run `enable_root.sh` to enable the root account via SSH:

```bash
sudo chmod +x enable_root.sh && sudo ./enable_root.sh
```

## NVIDIA Driver Installation

Use `install_nvidia_rtx2060.sh` inside a privileged Debian container to install the NVIDIA drivers:

```bash
sudo chmod +x install_nvidia_rtx2060.sh && sudo ./install_nvidia_rtx2060.sh
```

