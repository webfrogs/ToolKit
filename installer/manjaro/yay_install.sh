#!/bin/sh
set -e

sudo pacman -Syy
if test ! -x "$(command -v go)"; then
  sudo pacman -S go
  # go env -w GOPROXY=https://goproxy.cn,direct
fi

if test ! -x "$(command -v make)"; then
  sudo pacman -S base-devel
fi

# install yay
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay

