#!/bin/sh
set -e

cd $(dirname $0)
workDir=$(pwd)

installNeed="y"
if test -x "$(command -v i3)"; then
	echo "[INFO] i3 has been installed."
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
		/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2020.02.03_all.deb keyring.deb SHA256:c5dd35231930e3c8d6a9d9539c846023fe1a08e4b073ef0d2833acd815d80d48
		sudo dpkg -i ./keyring.deb
		echo "deb https://debian.sur5r.net/i3/ ${ubuntuCodeName} universe" \
				| sudo tee /etc/apt/sources.list.d/sur5r-i3.list > /dev/null
		sudo apt update
		sudo apt install -y i3
		sudo apt install -y dmenu
		sudo apt-get install -y i3status
		sudo apt-get install -y i3lock
  elif test -x "$(command -v pacman)"; then
    sudo pacman -Syy i3-wm i3lock i3status dmenu feh
    # for backgound image
    sudo pacman -S feh variety compton
	else
		echo "Can not install in current OS"
		exit 1
	fi
fi

i3ConfigFiles=($(ls ${workDir}/config))

echo ""
echo "[INFO] install i3 config file"
echo "i3 config file list:"
index=0
while test $index -lt ${#i3ConfigFiles[@]}; do
  echo " $(expr $index + 1). ${i3ConfigFiles[index]}"
  index=$(expr $index + 1)
done
read -p "Which one do you choose: " selectedIndex
if test $selectedIndex -lt 1 -o $selectedIndex -gt ${#i3ConfigFiles[@]}; then
  echo "[ERROR] input is invalid."
  exit 2
fi

mkdir -p ${HOME}/.config/i3/
if test -f "${HOME}/.config/i3/config"; then
	rm -f "${HOME}/.config/i3/config"
fi
ln -sf ${workDir}/config/${i3ConfigFiles[$(expr $selectedIndex - 1)]} ${HOME}/.config/i3/config
echo "[INFO] i3 config file '"${i3ConfigFiles[$(expr $selectedIndex - 1)]}"' is installed successfully."

