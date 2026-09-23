#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "╔══════════════════════════════════════════════╗"
echo "║      PRINCE • ONE-COMMAND SETUP             ║"
echo "╚══════════════════════════════════════════════╝"
echo

if [ -z "${PREFIX:-}" ]; then
    echo "[✗] This must be run inside Termux."
    exit 1
fi

REPO_URL="https://github.com/xno429175-bot/termux-debian-lxde-prince.git"
DIR="$HOME/termux-debian-lxde-prince"

if ! command -v git >/dev/null 2>&1; then
    echo "[+] Installing Git..."
    pkg install -y git
fi

if [ -d "$DIR/.git" ]; then
    echo "[✓] Repository already exists."
    cd "$DIR"
    git pull --ff-only
else
    echo "[+] Downloading Prince's Debian LXDE setup..."
    git clone "$REPO_URL" "$DIR"
    cd "$DIR"
fi

chmod +x install.sh start.sh setup.sh
echo
echo "[+] Running installer..."
bash install.sh
