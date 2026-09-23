#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "[+] Updating the GitHub project files..."
git pull --ff-only

echo "[+] Updating Debian packages..."
proot-distro login debian -- bash -lc '
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
'

echo "[✓] Update complete."
