#!/bin/sh
set -e

sudo tee -a /etc/NetworkManager/conf.d/90-disable-wifi-mac-spoofing.conf >/dev/null <<'EOF'
[device-mac-randomization]
wifi.scan-rand-mac-address=no

[connection-mac-randomization]
ethernet.cloned-mac-address=permanent
wifi.cloned-mac-address=permanent
EOF

sudo systemctl restart NetworkManager
