#!/bin/sh
set -e

sudo sed -i '/mirrors.tuna.tsinghua.edu.cn/d' /etc/pacman.d/mirrorlist
sudo sed -i '1i\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

sudo pacman -Syy
