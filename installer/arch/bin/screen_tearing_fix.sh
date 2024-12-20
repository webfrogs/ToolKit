#!/bin/sh
set -e

# Run this script to fix screen tearing problem for intel Graphics machine
# https://wiki.archlinux.org/title/intel_graphics#Tearing

sudo tee -a /etc/X11/xorg.conf.d/20-intel.conf >/dev/null <<'EOF'
Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"

  Option "TearFree" "true"
  Option "TripleBuffer" "true"
EndSection
EOF
