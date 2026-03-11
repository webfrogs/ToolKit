#!/bin/bash
set -e
set -o pipefail

cd $(dirname $0)

echo "INFO: please make sure that pacman multilib repo is active."

sudo pacman -Syy

echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  steam lutris umu-launcher

yay -S protonup-qt

