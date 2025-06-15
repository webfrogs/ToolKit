#!/bin/sh
set -e

sudo tee /etc/X11/xorg.conf.d/10-monitor.conf >/dev/null <<EOF
Section "Monitor"
    Identifier "eDp-1"
    Option "Rotate" "right"
EndSection
EOF

sudo tee /etc/X11/xorg.conf.d/99-touchscreen-rotation.conf >/dev/null <<EOF
Section "InputClass"
    Identifier      "Touchscreen rotation"
    MatchProduct    "FTS3528:00 2808:1015"
    Option          "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
EndSection
EOF

sudo systemctl restart sddm
