#!/bin/sh
set -e

sudo modprobe wireguard
echo 'wireguard' | sudo tee /etc/modules-load.d/wireguard.conf

sudo pacman -S wireguard-tools --noconfirm

