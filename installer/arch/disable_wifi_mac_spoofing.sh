#!/bin/sh
set -e

sudo tee -a /etc/NetworkManager/conf.d/90-disable-wifi-mac-spoofing.conf >/dev/null <<'EOF'
[device-mac-randomization]
wifi.scan-rand-mac-address=no

#[connection-mac-randomization]
#ethernet.cloned-mac-address=random
#wifi.cloned-mac-address=random
EOF

sudo systemctl restart NetworkManager
