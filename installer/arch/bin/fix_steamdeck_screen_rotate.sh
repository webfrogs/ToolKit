#!/bin/sh
set -e

sudo tee /etc/X11/xorg.conf.d/10-monitor.conf >/dev/null <<EOF
Section "Monitor"
    Identifier "eDp-1"
    Option "Rotate" "right"
EndSection
EOF

sudo systemctl restart sddm
