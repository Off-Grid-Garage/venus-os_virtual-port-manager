#!/bin/sh

echo "Enabling Virtual Port Manager services..."

ln -sf /data/etc/runit/socat-ttyV0 /service/socat-ttyV0
ln -sf /data/etc/runit/dbus-serialbattery-ttyV0 /service/dbus-serialbattery-ttyV0
ln -sf /data/etc/runit/virtual-port-watchdog /service/virtual-port-watchdog

# Give runit a moment to create supervise dirs
sleep 1

svc -u /service/socat-ttyV0
svc -u /service/dbus-serialbattery-ttyV0
svc -u /service/virtual-port-watchdog

# Patch /data/rc.local
echo "Patching /data/rc.local..."

RCLOCAL="/data/rc.local"

# Create rc.local if missing
if [ ! -f "$RCLOCAL" ]; then
    echo "#!/bin/bash" > "$RCLOCAL"
    echo "" >> "$RCLOCAL"
fi

chmod +x "$RCLOCAL"

# Only append block if not already present
if ! grep -q "JK-PB virtual port services" "$RCLOCAL"; then
    cat >> "$RCLOCAL" << 'EOF'
# --- JK-PB virtual port services ---
ln -sf /data/etc/runit/socat-ttyV0 /service/socat-ttyV0
ln -sf /data/etc/runit/dbus-serialbattery-ttyV0 /service/dbus-serialbattery-ttyV0

svc -u /service/socat-ttyV0
svc -u /service/dbus-serialbattery-ttyV0
# --- end JK-PB block ---

EOF
fi

# Patch rc.local for watchdog service
if ! grep -q "Virtual Port Watchdog" "$RCLOCAL"; then

    echo "Patching /data/rc.local with watchdog service..."

    cat >> /data/rc.local << 'EOF'
# --- Virtual Port Watchdog ---
ln -sf /data/etc/runit/virtual-port-watchdog /service/virtual-port-watchdog
svc -u /service/virtual-port-watchdog
# --- end watchdog block ---
EOF
fi

echo "VPM Services enabled."
