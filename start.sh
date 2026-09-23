#!/data/data/com.termux/files/usr/bin/bash
set -e

if [ -f "$HOME/start-prince-lxde.sh" ]; then
    exec bash "$HOME/start-prince-lxde.sh"
fi

echo "[!] Setup has not been installed yet."
echo "Run:"
echo "  bash install.sh"
