#!/bin/sh
set -e

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay

