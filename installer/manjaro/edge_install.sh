#!/bin/sh
set -e

# yay -S microsoft-edge-stable

cd /tmp
git clone https://aur.archlinux.org/microsoft-edge-stable-bin.git
cd microsoft-edge-stable-bin
makepkg -si
cd ..
rm -rf microsoft-edge-stable-bin
