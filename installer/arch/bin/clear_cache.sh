#!/bin/sh
set -e

sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
docker system prune -f -a

