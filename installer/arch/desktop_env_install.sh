#!/bin/sh
set -e
set -o pipefail

cd $(dirname $0)

sudo pacman -Syy

echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  sddm plasma plasma-wayland-session dolphin

echo "==> install nerd font."
../fonts/nerd_font_install.sh IosevkaTerm

echo "==> install i3wm packages."
../i3/install.sh
