#!/bin/sh
set -e

cd $(dirname $0)
sudo pacman -S --noconfirm ghostty kitty
../../../configs/tty/config.sh
