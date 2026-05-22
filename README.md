# Virtual Port Manager (VPM) for Venus OS

## Overview

The Virtual Port Manager provides a scalable, stable, and reproducible way to expose multiple JK‑PB BMS units over a single RS485‑TCP interface (e.g., Waveshare RS485‑to‑Ethernet: https://s.click.aliexpress.com/e/_c4nhBqYP) to Venus OS.

It creates virtual PTY devices (`/dev/ttyV0`, `/dev/ttyV1`, …) and manages:

- socat TCP→PTY bridges  
- runit service supervision  
- automatic restart logic  
- clean shutdown  
- multi‑BMS polling  
- integration with dbus‑serialbattery  
- operator‑friendly restart/status tooling  

This enables Venus OS to treat each BMS as if it were connected to a dedicated USB‑RS485 adapter — even when all BMS are connected to a single RS485 bus.

---

## Features

- Supports up to 15 JK‑PB BMS on a single RS485 bus  
- Creates stable virtual serial ports (`/dev/ttyV0__0x01`, `/dev/ttyV0__0x02`, …)  
- Fully supervised via runit  
- Automatic recovery if Waveshare reboots or drops TCP  
- Clean restart scripts for:
  - dbus‑serialbattery  
  - virtual port manager  
  - socat  
  - all channels  
- Zero runtime artefacts in the repo (installer generates everything)  
- Compatible with Holger’s multi‑BMS branch of dbus‑serialbattery  
- Designed for upstream integration into the Victron ecosystem  

---

## Folder Structure

```
virtual-port-manager/
├── bin/
├── install.sh
├── vpm-install.sh
├── uninstall.sh
├── enable.sh
├── disable.sh
├── restart.sh
├── restart_socat.sh
├── runit-templates/
├── status.sh
├── README.md
├── CHANGELOG
├── config.ini
└── VERSION
```

---

## What’s NOT included

Runtime folders such as:

- `/service/vsp-*`  
- `/service/socat-*`  
- `supervise/`  
- `log/`  

These are created dynamically by the installer on the user’s Venus OS device.

---

## Installation

SSH into your Venus OS device and run:

```
wget -O /tmp/vpm-install.sh https://raw.githubusercontent.com/Off-Grid-Garage/venus-os_virtual-port-manager/main/vpm-install.sh
sh /tmp/vpm-install.sh
```

This online installer will:
- download the latest Virtual Port Manager package
- extract it into /data/apps/virtual-port-manager
- run the local install.sh
- create runit service templates under /data/etc/runit/
- create /service/ symlinks
- create virtual PTYs
- start socat bridges
- start dbus-serialbattery instances
- validate connectivity to the Waveshare
- print a status summary

A reboot is recommended after installation.


Manual Installation (advanced users)
If you manually copy the project into:
```
/data/apps/virtual-port-manager
```
…then run:
```
sh install.sh
```
This performs the same setup steps as the online installer, but without downloading the project.

---

## Uninstallation

To remove all virtual ports and services:

```
sh uninstall.sh
```

This will:

- stop all `vsp-*` and `socat-*` services  
- remove runit service folders  
- remove `/service/` symlinks  
- clean up PTY devices  
- leave no residue on the system  

---

## Configuration

Edit `config.ini` to define:

```
# IP address of the Waveshare RS485-to-Ethernet adapter
IP=10.0.0.3

# TCP port of the Waveshare (usually 9999)
PORT=9999

# Virtual serial port name
VIRTUAL_PORT=/dev/ttyV0
```

---

## Restarting Services

```
restart-virtual-ports.sh          → restart channel 0
restart-virtual-ports.sh 0        → restart channel 0
restart-virtual-ports.sh all      → restart all channels
restart-virtual-ports.sh 0 1 2    → restart channels 0,1,2
restart_socat.sh                  → restart socat only
```

---

## Status

Check the health of all virtual ports:

```
sh status.sh
```

Shows:

- VPM version  
- Waveshare TCP config  
- dbus‑serialbattery PID  
- socat PID  
- PTY status  
- dbus‑serialbattery service status  
- watchdog status  
- TCP connectivity  
- last 10 watchdog entries  

---

## Service Lifecycle: Enable / Disable Virtual Port Manager

The Virtual Port Manager installs three persistent runit services:

- `socat-ttyV0` – creates the virtroot@raspberrypi2:/data/apps/virtual-port-manager# cat README.md
# Virtual Port Manager (VPM) for Venus OS

## Overview

The Virtual Port Manager provides a scalable, stable, and reproducible way to expose multiple JK‑PB BMS units over a single RS485‑TCP interface (e.g., Waveshare RS485‑to‑Ethernet: https://s.click.aliexpress.com/e/_c4nhBqYP) to Venus OS.

It creates virtual PTY devices (`/dev/ttyV0`, `/dev/ttyV1`, …) and manages:

- socat TCP→PTY bridges
- runit service supervision
- automatic restart logic
- clean shutdown
- multi‑BMS polling
- integration with dbus‑serialbattery
- operator‑friendly restart/status tooling

This enables Venus OS to treat each BMS as if it were connected to a dedicated USB‑RS485 adapter — even when all BMS are connected to a single RS485 bus.

---

## Features

- Supports up to 15 JK‑PB BMS on a single RS485 bus
- Creates stable virtual serial ports (`/dev/ttyV0__0x01`, `/dev/ttyV0__0x02`, …)
- Fully supervised via runit
- Automatic recovery if Waveshare reboots or drops TCP
- Clean restart scripts for:
  - dbus‑serialbattery
  - virtual port manager
  - socat
  - all channels
- Zero runtime artefacts in the repo (installer generates everything)
- Compatible with Holger’s multi‑BMS branch of dbus‑serialbattery
- Designed for upstream integration into the Victron ecosystem

---

## Folder Structure

```
virtual-port-manager/
├── bin/
├── install.sh
├── vpm-install.sh
├── uninstall.sh
├── enable.sh
├── disable.sh
├── restart.sh
├── restart_socat.sh
├── runit-templates/
├── status.sh
├── README.md
├── CHANGELOG
├── config.ini
└── VERSION
```

---

## What’s NOT included

Runtime folders such as:

- `/service/vsp-*`
- `/service/socat-*`
- `supervise/`
- `log/`

These are created dynamically by the installer on the user’s Venus OS device.

---

## Installation

SSH into your Venus OS device and run:

```
wget -O /tmp/vpm-install.sh https://raw.githubusercontent.com/Off-Grid-Garage/venus-os_virtual-port-manager/main/vpm-install.sh
sh /tmp/vpm-install.sh
```

This online installer will:
- download the latest Virtual Port Manager package
- extract it into /data/apps/virtual-port-manager
- run the local install.sh
- create runit service templates under /data/etc/runit/
- create /service/ symlinks
- create virtual PTYs
- start socat bridges
- start dbus-serialbattery instances
- validate connectivity to the Waveshare
- print a status summary

A reboot is recommended after installation.



Manual Installation (advanced users)
If you manually copy the project into:
```
/data/apps/virtual-port-manager
```
…then run:
```
sh install.sh
```
This performs the same setup steps as the online installer, but without downloading the project.

---

## Uninstallation

To remove all virtual ports and services:

```
sh uninstall.sh
```

This will:

- stop all `vsp-*` and `socat-*` services
- remove runit service folders
- remove `/service/` symlinks
- clean up PTY devices
- leave no residue on the system

---

## Configuration

Edit `config.ini` to define:

```
# IP address of the Waveshare RS485-to-Ethernet adapter
IP=10.0.0.3

# TCP port of the Waveshare (usually 9999)
PORT=9999

# Virtual serial port name
VIRTUAL_PORT=/dev/ttyV0
```

---

## Restarting Services

```
restart-virtual-ports.sh          → restart channel 0
restart-virtual-ports.sh 0        → restart channel 0
restart-virtual-ports.sh all      → restart all channels
restart-virtual-ports.sh 0 1 2    → restart channels 0,1,2
restart_socat.sh                  → restart socat only
```

---

## Status

Check the health of all virtual ports:

```
sh status.sh
```

Shows:

- VPM version
- Waveshare TCP config
- dbus‑serialbattery PID
- socat PID
- PTY status
- dbus‑serialbattery service status
- watchdog status
- TCP connectivity
- last 10 watchdog entries

---

## Service Lifecycle: Enable / Disable Virtual Port Manager

The Virtual Port Manager installs three persistent runit services:

- `socat-ttyV0` – creates the virtual serial port
- `dbus-serialbattery-ttyV0` – publishes JK‑PB data to DBus
- `virtual-port-watchdog` – monitors PTY, socat, and TCP connectivity

These services are defined under:

```
/data/etc/runit/<service>
```

and supervised by runit via symlinks under:

```
/service/<service>
```

### Disable the Virtual Port Manager

Stops all services cleanly and removes their supervision:

```
sh /data/apps/virtual-port-manager/disable.sh
```

This script:

- sends `svc -d` to stop each service
- removes the `/service` symlinks
- removes rc.local autostart blocks
- prevents runit from restarting them

After disabling, `/dev/ttyV0` disappears and DBus entries are removed.

### Enable the Virtual Port Manager

Recreates supervision and starts all services:

```
sh /data/apps/virtual-port-manager/enable.sh
```

This script:

- recreates the `/service` symlinks
- patches rc.local with autostart blocks
- triggers runit to spawn new supervise processes
- starts all services via `svc -u`

After enabling, `/dev/ttyV0` reappears and DBus entries repopulate.

---

## Testing & Validation

Version 1.0.0 has been fully validated on Venus OS (Pi2) with 15 JK‑PB BMS units.

The following failure modes were tested and confirmed to recover automatically:

- Waveshare TCP drop / reboot
- GX device reboot
- socat process termination
- dbus‑serialbattery process termination
- PTY disappearance (`/dev/ttyV0` removed)
- watchdog process termination
- temporary TCP session hijack (`nc` stealing the port)

In all cases:

- runit restarted the affected service within 1–2 seconds
- the watchdog detected persistent failures and logged recovery actions
- all 15 BMS reappeared on DBus without manual intervention
- no zombie processes or stale supervise directories were observed

This confirms the Virtual Port Manager is stable, self‑healing, and production‑ready.

---

## Compatibility

Tested with:

- Venus OS 3.72
- Raspberry Pi 3B+
- Waveshare 4/8‑Channel RS485‑to‑Ethernet POE in TCP server mode
  https://s.click.aliexpress.com/e/_c4nhBqYP
- JK‑PB BMS V14, V15, V19 (firmware V14.24, V15.31, V19.31, V19.31B)
- @hsteinhaus multi‑BMS branch of dbus‑serialbattery
  https://github.com/hsteinhaus/venus-os_dbus-serialbattery

---

## Notes for Developers

This project is designed to be integrated into:

- @hsteinhaus dbus‑serialbattery
  https://github.com/hsteinhaus/venus-os_dbus-serialbattery
- @mr-manuel upstream Victron driver
  https://github.com/mr-manuel/venus-os_dbus-serialbattery
- future multi‑port RS485 architectures

The installer is idempotent and safe to run multiple times.

---

## Acknowledgements

- @hsteinhaus — multi‑BMS driver development
- @mr-manuel — upstream Victron integrationual serial port  
- `dbus-serialbattery-ttyV0` – publishes JK‑PB data to DBus  
- `virtual-port-watchdog` – monitors PTY, socat, and TCP connectivity  

These services are defined under:

```
/data/etc/runit/<service>
```

and supervised by runit via symlinks under:

```
/service/<service>
```

### Disable the Virtual Port Manager

Stops all services cleanly and removes their supervision:

```
sh /data/apps/virtual-port-manager/disable.sh
```

This script:

- sends `svc -d` to stop each service  
- removes the `/service` symlinks  
- removes rc.local autostart blocks  
- prevents runit from restarting them  

After disabling, `/dev/ttyV0` disappears and DBus entries are removed.

### Enable the Virtual Port Manager

Recreates supervision and starts all services:

```
sh /data/apps/virtual-port-manager/enable.sh
```

This script:

- recreates the `/service` symlinks  
- patches rc.local with autostart blocks  
- triggers runit to spawn new supervise processes  
- starts all services via `svc -u`  

After enabling, `/dev/ttyV0` reappears and DBus entries repopulate.

---

## Testing & Validation

Version 1.0.0 has been fully validated on Venus OS (Pi2) with 15 JK‑PB BMS units.

The following failure modes were tested and confirmed to recover automatically:

- Waveshare TCP drop / reboot  
- GX device reboot  
- socat process termination  
- dbus‑serialbattery process termination  
- PTY disappearance (`/dev/ttyV0` removed)  
- watchdog process termination  
- temporary TCP session hijack (`nc` stealing the port)  

In all cases:

- runit restarted the affected service within 1–2 seconds  
- the watchdog detected persistent failures and logged recovery actions  
- all 15 BMS reappeared on DBus without manual intervention  
- no zombie processes or stale supervise directories were observed  

This confirms the Virtual Port Manager is stable, self‑healing, and production‑ready.

---

## Compatibility

Tested with:

- Venus OS 3.72  
- Raspberry Pi 3B+  
- Waveshare 4/8‑Channel RS485‑to‑Ethernet POE in TCP server mode  
  https://s.click.aliexpress.com/e/_c4nhBqYP  
- JK‑PB BMS V14, V15, V19 (firmware V14.24, V15.31, V19.31, V19.31B)  
- @hsteinhaus multi‑BMS branch of dbus‑serialbattery  
  https://github.com/hsteinhaus/venus-os_dbus-serialbattery  

---

## Notes for Developers

This project is designed to be integrated into:

- @hsteinhaus dbus‑serialbattery  
  https://github.com/hsteinhaus/venus-os_dbus-serialbattery  
- @mr-manuel upstream Victron driver  
  https://github.com/mr-manuel/venus-os_dbus-serialbattery  
- future multi‑port RS485 architectures  

The installer is idempotent and safe to run multiple times.

---

## Acknowledgements

- @hsteinhaus — multi‑BMS driver development  
- @mr-manuel — upstream Victron integration  
