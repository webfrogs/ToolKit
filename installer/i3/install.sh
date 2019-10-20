#!/bin/sh
set -e

cd /tmp

/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb

if test -x "$(command -v apt-get)"; then
    ubuntuCodeName=$(lsb_release -cs)
    if test -f "/etc/lsb-release"; then
        distribID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F"=" '{ print $2 }')
        if test ${distribID} = "LinuxMint"; then
            ubuntuCodeName=$(grep "UBUNTU_CODENAME" /etc/os-release | awk -F"=" '{ print $2 }')
        fi
    fi

    echo "deb https://debian.sur5r.net/i3/ ${ubuntuCodeName} universe" \
        | sudo tee /etc/apt/sources.list.d/sur5r-i3.list > /dev/null
    sudo apt update
    sudo apt install -y i3
		sudo apt-get install -y i3status
else
    echo "Can not install in current OS"
    exit 1
fi
