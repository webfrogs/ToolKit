#!/bin/sh
set -e

sudo mkdir -p /etc/sddm.conf.d

sudo tee /etc/sddm.conf.d/hidpi.conf > /dev/null <<EOF
[General]
GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192
EOF

echo "Done."

