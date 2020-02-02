#!/bin/sh
set -e

cd $(dirname $0)
workDir=$(pwd)

installNeed="y"
if test -x "$(command -v i3)"; then
	echo "[Info] i3 has been installed."
	read -p "Need reinstall? [y/n] " installNeed
fi

if test "${installNeed}" = "y"; then
	if test -x "$(command -v apt-get)"; then
		ubuntuCodeName=$(lsb_release -cs)
		if test -f "/etc/lsb-release"; then
			distribID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F"=" '{ print $2 }')
			if test ${distribID} = "LinuxMint"; then
				ubuntuCodeName=$(grep "UBUNTU_CODENAME" /etc/os-release | awk -F"=" '{ print $2 }')
			fi
		fi

		cd /tmp
		/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
		sudo dpkg -i ./keyring.deb
		echo "deb https://debian.sur5r.net/i3/ ${ubuntuCodeName} universe" \
				| sudo tee /etc/apt/sources.list.d/sur5r-i3.list > /dev/null
		sudo apt update
		sudo apt install -y i3
		sudo apt install -y dmenu
		sudo apt-get install -y i3status
		sudo apt-get install -y i3lock
	else
		echo "Can not install in current OS"
		exit 1
	fi
fi

mkdir -p ${HOME}/.config/i3/
if test -f "${HOME}/.config/i3/config"; then
	rm -f "${HOME}/.config/i3/config"
fi
ln -sf ${workDir}/i3_config ${HOME}/.config/i3/config

