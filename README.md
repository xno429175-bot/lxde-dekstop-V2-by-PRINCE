# Prince's Termux Debian LXDE

A lightweight Debian LXDE desktop for Android using **Termux + Debian + LXDE + Termux:X11**.

**Created by Prince.**

## Features

- Debian Linux on Android
- Lightweight LXDE desktop
- Termux:X11 display
- No VNC
- Existing Debian/LXDE detection
- Simple installer
- One-command setup
- Installation checker
- Debian update command
- Beginner-friendly commands

## Architecture

```text
Android
   ↓
Termux
   ↓
proot-distro
   ↓
Debian
   ↓
LXDE
   ↓
DISPLAY=:0
   ↓
Termux:X11
   ↓
Linux Desktop
```

## Requirements

- Android
- Termux
- Termux:X11 Android application
- Internet for first setup
- Storage for Debian/LXDE

## Recommended installation

### 1. Install the Termux:X11 Android app

Install the Termux:X11 app separately.

Then open **normal Termux**.

### 2. One-command setup

```bash
pkg update
pkg install git -y
git clone git@github.com:xno429175-bot/lxde-dekstop-V2-by-PRINCE.git
cd lxde-dekstop-V2-by-PRINCE
chmod +x setup.sh
./setup.sh
```

The setup script downloads the project and starts the installer.

## Alternative installation

```bash
git clone git@github.com:xno429175-bot/lxde-dekstop-V2-by-PRINCE.git
cd lxde-dekstop-V2-by-PRINCE
chmod +x install.sh
./install.sh
```

## Start LXDE

After installation:

```bash
prince-lxde start
```

Or:

```bash
bash ~/start-prince-lxde.sh
```

## Check the installatgit clone git@github.com:xno429175-bot/lxde-dekstop-V2-by-PRINCE.git
cd lxde-dekstop-V2-by-PRINCE
chmod +x install.sh
./install.shion

```bash
prince-lxde check
```

You should see checks for:

```text
Termux
proot-distro
Termux:X11
Debian
LXDE
```

## Enter Debian

```bash
prince-lxde enter
```

## Update Debian

```bash
prince-lxde update
```

## Stop LXDE

LXDE runs in the current Termux session.

Press:

```text
CTRL + C
```

to close the session.

## Important

This project does **not** use VNC.

The installer tries to preserve existing Debian and LXDE installations instead of reinstalling them unnecessarily.

Run the setup from **normal Termux**, not from inside Debian.

## Project files

```text
termux-debian-lxde-prince/
├── install.sh
├── setup.sh
├── start.sh
├── update.sh
├── README.md
└── LICENSE
```

## Author

**Prince**

## License

MIT
