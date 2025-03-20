#!/bin/sh
set -e

cd $(dirname $0)

sudo pacman -S --noconfirm ghostty

../../../configs/ghostty/config.sh
