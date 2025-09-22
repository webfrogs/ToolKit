#!/bin/sh
set -e

# this device should rotate to left

# use command 'xrandr' to find monitor
sudo tee /etc/X11/xorg.conf.d/10-monitor.conf >/dev/null <<EOF
Section "Monitor"
    Identifier "eDp-1"
    Option "Rotate" "left"
EndSection
EOF

# 1. use command 'xinput list' to find touchscreen name
# 2. config xorg to rotate touchscreen
sudo tee /etc/X11/xorg.conf.d/99-touchscreen-rotation.conf >/dev/null <<EOF
Section "InputClass"
    Identifier      "Touchscreen rotation"
    MatchProduct    "NVTK0603:00 0603:F001"
    Option          "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
EndSection
EOF

sudo systemctl restart sddm
