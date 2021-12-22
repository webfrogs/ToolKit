#!/bin/sh
set -e

sudo tee -a /etc/X11/xorg.conf.d/20-intel.conf >/dev/null <<'EOF'
Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"

  Option "TearFree" "true"
  Option "TripleBuffer" "true"
EndSection
EOF
