#!/bin/sh
set -e

if test ! -x "$(command -v wg)"; then
  sudo pacman -S wireguard-tools --noconfirm
  echo "need reboot to use wireguard."
  exit 0
fi

sudo modprobe wireguard
echo 'wireguard' | sudo tee /etc/modules-load.d/wireguard.conf

sudo systemctl enable --now systemd-resolved.service

