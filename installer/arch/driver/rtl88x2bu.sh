#!/bin/sh
set -e

if lsmod | grep -q '^888x2bu'; then
  echo "driver has been installed. no need to reinstall"
  exit 0
fi

sudo pacman -S bc dkms linux-lts-headers
cd /tmp
rm -rf rtl88x2bu
git clone https://github.com/cilynx/rtl88x2bu.git
cd rtl88x2bu
sudo dkms add ./rtl88x2bu
sudo dkms autoinstall
dkms status

echo "blacklist rtw88_8822bu" | sudo tee /etc/modprobe.d/rtw8822bu.conf

echo "driver is installed. reboot OS to make it work."
