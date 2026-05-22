#!/bin/bash

set -e

APPDIR="/data/apps/virtual-port-manager"
TMPDIR="/tmp/vpm-download"
URL="https://github.com/Off-Grid-Garage/venus-os_virtual-port-manager/archive/refs/heads/main.tar.gz"

echo ""
echo "=== Virtual Port Manager Online Installer ==="
echo ""

# Check dependencies
command -v wget >/dev/null 2>&1 || { echo "Error: wget not found"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "Error: tar not found"; exit 1; }

echo "Preparing temporary directory..."
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

echo "Downloading VPM package..."
if ! wget -q -O "$TMPDIR/vpm.tar.gz" "$URL"; then
    echo "Error: Failed to download VPM package."
    exit 1
fi

echo "Creating application directory..."
mkdir -p "$APPDIR"

echo "Extracting package..."
tar -xzf "$TMPDIR/vpm.tar.gz" -C "$APPDIR" --strip-components=1

if [ ! -f "$APPDIR/install.sh" ]; then
    echo "Error: install.sh not found inside extracted package."
    exit 1
fi

echo "Running local installer..."
chmod +x "$APPDIR/install.sh"
bash "$APPDIR/install.sh"

echo ""
echo "=== VPM installation complete ==="
echo "You may reboot your device to activate all services."
echo ""
