#!/bin/sh
set -e

# install yay
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay

