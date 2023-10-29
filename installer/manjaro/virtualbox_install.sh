#!/bin/sh
set -e

sudo pacman -Syy

linux_kernel=$(mhwd-kernel -li | grep '*' | awk '{print $2}')
sudo pacman -S virtualbox ${linux_kernel}-virtualbox-host-modules
sudo vboxreload
