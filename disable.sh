#!/bin/sh

echo "Disabling Virtual Port Manager services..."

# Stop services cleanly
svc -d /service/socat-ttyV0 2>/dev/null
svc -d /service/dbus-serialbattery-ttyV0 2>/dev/null
svc -d /service/virtual-port-watchdog 2>/dev/null

sleep 1

# Remove symlinks so they don't restart
rm -f /service/socat-ttyV0
rm -f /service/dbus-serialbattery-ttyV0
rm -f /service/virtual-port-watchdog

# 3. Remove rc.local blocks (marker-based)
RCLOCAL="/data/rc.local"

echo "Cleaning up /data/rc.local..."

if [ -f "$RCLOCAL" ]; then
    # Remove JK-PB block
    sed -i '/# --- JK-PB virtual port services ---/,/# --- end JK-PB block ---/d' "$RCLOCAL"

    # Remove Virtual Port Watchdog block
    sed -i '/# --- Virtual Port Watchdog ---/,/# --- end watchdog block ---/d' "$RCLOCAL"
fi

echo "VPM Services disabled."
