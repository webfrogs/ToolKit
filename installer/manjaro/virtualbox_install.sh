#!/bin/sh
set -e

#linux_kernel=$(mhwd-kernel -li | grep '*' | awk '{print $2}')
sudo pacman -Syu virtualbox ${linux_kernel}-virtualbox-host-modules
sudo vboxreload
