#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

apt install linux-headers-$(uname -r) build-essential dkms git

cd /tmp
if [ -d "rtl8814AU" ]; then
    rm -rf rtl8814AU
fi

git clone https://github.com/webfrogs/rtl8814AU.git
cd rtl8814AU
cp -R . /usr/src/rtl8814au-4.3.21
dkms build -m rtl8814au -v 4.3.21
dkms install -m rtl8814au -v 4.3.21

cd ..
rm -rf rtl8814AU

echo "Driver is installed successfully, reboot to take effect."