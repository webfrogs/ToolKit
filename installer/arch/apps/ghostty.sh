#!/bin/sh
set -e

sudo pacman -S --noconfirm ghostty

tee ${HOME}/.config/ghostty/config >/dev/null <<'EOF'
font-family = "IosevkaTerm Nerd Font Mono"
font-size = 16
# keybind = ctrl+w=close_surface
EOF
