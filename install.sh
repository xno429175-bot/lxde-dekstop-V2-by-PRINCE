#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO_NAME="termux-debian-lxde-prince"
VERSION="2.0.0"

clear
cat <<'EOF'
╔══════════════════════════════════════════════════╗
║                                                  ║
║        PRINCE • DEBIAN LXDE INSTALLER           ║
║                                                  ║
║        Termux + Debian + LXDE + Termux:X11      ║
║                                                  ║
╚══════════════════════════════════════════════════╝
EOF

echo
echo "Version : $VERSION"
echo "Author  : Prince"
echo

if [ -z "${PREFIX:-}" ]; then
    echo "[✗] Run this script from normal Termux."
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    echo "[!] Do not run this installer as root."
    exit 1
fi

echo "[1/5] Checking Termux..."
command -v pkg >/dev/null 2>&1 || {
    echo "[✗] Termux package manager not found."
    exit 1
}
echo "[✓] Termux detected."

echo
echo "[2/5] Installing required Termux packages..."
pkg install -y proot-distro
echo "[✓] proot-distro ready."

echo
echo "[3/5] Checking Debian..."
if proot-distro login debian -- true >/dev/null 2>&1; then
    echo "[✓] Debian is already installed. Keeping your existing Debian."
else
    echo "[+] Debian not found. Installing Debian..."
    proot-distro install debian
    echo "[✓] Debian installed."
fi

echo
echo "[4/5] Checking Termux:X11 package..."
if command -v termux-x11 >/dev/null 2>&1; then
    echo "[✓] Termux:X11 package is already installed."
else
    echo "[+] Enabling X11 repository..."
    pkg install -y x11-repo
    echo "[+] Installing Termux:X11 package..."
    pkg install -y termux-x11-nightly
    echo "[✓] Termux:X11 package installed."
fi

echo
echo "[5/5] Checking LXDE inside Debian..."
proot-distro login debian -- bash -lc '
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update

if dpkg-query -W -f="${Status}" lxde-core 2>/dev/null | grep -q "install ok installed"; then
    echo "[✓] LXDE is already installed. No reinstall needed."
else
    echo "[+] Installing lightweight LXDE..."
    apt-get install -y lxde-core lxterminal dbus-x11 x11-xserver-utils
    echo "[✓] LXDE installed."
fi

mkdir -p /tmp/runtime-prince
chmod 700 /tmp/runtime-prince
'

cat > "$HOME/prince-lxde" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
exec bash "$HOME/.prince-lxde-command" "$@"
EOF
chmod +x "$HOME/prince-lxde"

cat > "$HOME/.prince-lxde-command" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -e

case "${1:-help}" in
  start)
    exec bash "$HOME/start-prince-lxde.sh"
    ;;
  enter)
    exec proot-distro login debian
    ;;
  check)
    echo "=== Prince Debian LXDE Check ==="
    echo
    printf "Termux:       "
    command -v pkg >/dev/null 2>&1 && echo "OK" || echo "MISSING"
    printf "proot-distro: "
    command -v proot-distro >/dev/null 2>&1 && echo "OK" || echo "MISSING"
    printf "Termux:X11:   "
    command -v termux-x11 >/dev/null 2>&1 && echo "OK" || echo "MISSING"
    printf "Debian:       "
    proot-distro login debian -- true >/dev/null 2>&1 && echo "OK" || echo "MISSING"
    printf "LXDE:         "
    proot-distro login debian -- bash -lc 'command -v startlxde >/dev/null 2>&1' && echo "OK" || echo "MISSING"
    ;;
  update)
    exec bash "$HOME/update-prince-lxde.sh"
    ;;
  help|*)
    echo
    echo "Prince Debian LXDE"
    echo
    echo "Commands:"
    echo "  prince-lxde start   Start Debian + LXDE + Termux:X11"
    echo "  prince-lxde enter   Enter Debian terminal"
    echo "  prince-lxde check   Check the installation"
    echo "  prince-lxde update  Update Debian packages"
    echo "  prince-lxde help    Show this help"
    echo
    ;;
esac
EOF
chmod +x "$HOME/.prince-lxde-command"

cat > "$HOME/start-prince-lxde.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -e

clear
cat <<'BANNER'
╔══════════════════════════════════════════════════╗
║        PRINCE • DEBIAN LXDE DESKTOP             ║
╚══════════════════════════════════════════════════╝
BANNER
echo

command -v termux-x11 >/dev/null 2>&1 || {
    echo "[✗] Termux:X11 package is missing."
    echo "    Run: prince-lxde check"
    exit 1
}

proot-distro login debian -- true >/dev/null 2>&1 || {
    echo "[✗] Debian is missing."
    exit 1
}

echo "[+] Starting Termux:X11..."
termux-x11 :0 >/dev/null 2>&1 &
X11_PID=$!

cleanup() {
    kill "$X11_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

sleep 2

echo "[+] Connecting Debian to DISPLAY=:0..."
echo "[+] Starting LXDE..."
echo

proot-distro login debian --shared-tmp -- bash -lc '
set -e
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-prince
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

if command -v dbus-launch >/dev/null 2>&1; then
    exec dbus-launch --exit-with-session startlxde
else
    exec startlxde
fi
'
EOF
chmod +x "$HOME/start-prince-lxde.sh"

cat > "$HOME/update-prince-lxde.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "[+] Updating Debian package lists..."
proot-distro login debian -- bash -lc '
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
'
echo "[✓] Debian update complete."
EOF
chmod +x "$HOME/update-prince-lxde.sh"

echo
cat <<'EOF'
╔══════════════════════════════════════════════════╗
║              INSTALLATION COMPLETE ✓             ║
╚══════════════════════════════════════════════════╝
EOF
echo
echo "Created by Prince."
echo
echo "Start desktop:"
echo "  prince-lxde start"
echo
echo "Check installation:"
echo "  prince-lxde check"
echo
echo "Enter Debian:"
echo "  prince-lxde enter"
echo
echo "Update Debian:"
echo "  prince-lxde update"
echo
echo "IMPORTANT:"
echo "• Install the Termux:X11 Android app separately."
echo "• This project uses Termux:X11, not VNC."
echo "• Existing Debian and LXDE installations are preserved."
echo
