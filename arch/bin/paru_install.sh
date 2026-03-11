#!/bin/sh
set -e

sudo pacman -Syy
sudo pacman -S --needed base-devel
cd /tmp
rm -rf paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

