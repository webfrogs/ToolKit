#!/bin/sh
set -e

sudo pacman -S --noconfirm virtualbox virtualbox-host-modules-lts virtualbox-guest-iso

sudo gpasswd -a $USER vboxusers

# ---- manjaro

# sudo pacman -Syy

# linux_kernel=$(mhwd-kernel -li | grep '*' | awk '{print $2}')
# sudo pacman -S virtualbox ${linux_kernel}-virtualbox-host-modules virtualbox-guest-utils
# sudo vboxreload
# sudo pamac install virtualbox-guest-iso

# sudo gpasswd -a $USER vboxusers
