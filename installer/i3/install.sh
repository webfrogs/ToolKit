#!/bin/bash
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
    sudo pacman -Syy i3-wm i3lock i3status dmenu i3status-rust --noconfirm
    # for backgound image
    sudo pacman -S feh variety network-manager-applet picom polybar rofi xorg-xrandr --noconfirm
	else
		echo "Can not install in current OS"
		exit 1
	fi
fi

mkdir -p ${HOME}/Pictures/wallpapers

echo ""
echo "[INFO] install i3 config file"
mkdir -p ${HOME}/.config/i3/
rm -f "${HOME}/.config/i3/config"
cp ${workDir}/res/config ${HOME}/.config/i3/config

mkdir -p ${HOME}/.config/i3status-rust
ln -sf ${workDir}/res/i3status-rust-config.toml ${HOME}/.config/i3status-rust/config.toml

mkdir -p ${HOME}/.config/picom
ln -sf ${workDir}/picom/picom.conf ${HOME}/.config/picom/picom.conf

mkdir -p ${HOME}/.config/rofi
ln -sf ${workDir}/rofi/config.rasi ${HOME}/.config/rofi/config.rasi
ln -sf ${workDir}/rofi/nord.rasi ${HOME}/.config/rofi/nord.rasi

echo "[INFO] i3 config file is installed successfully."

# fix dolphin open file issue
if test ! -f "/etc/xdg/menus/applications.menu"; then
  if test -f "/etc/xdg/menus/plasma-applications.menu"; then
    sudo ln -s /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu
  fi
fi

echo ""
echo "[INFO] HiDPI support."
if test ! -e "$HOME/.Xresources"; then
  touch "$HOME/.Xresources"
fi
sed -i '/^Xft\.dpi:/d' $HOME/.Xresources

newDPI=""
echo "choose HiDPI screen resolution(default 1080p):"
echo "  1. 2k"
echo "  2. 4k"
read -p "Which one do you choose: " hidpiIndex
case "${hidpiIndex}" in
  1)
    # 2k
    newDPI="150"
    ;;
  2)
    # 4k
    newDPI="175"
    ;;
	*)
    echo "Skip HiDPI configuration."
    ;;
esac
if test -n "${newDPI}"; then
  echo "Xft.dpi: ${newDPI}" | tee -a $HOME/.Xresources
  echo "HiDPI is configured, reboot to make it work."
fi

