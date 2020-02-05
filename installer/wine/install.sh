#!/bin/sh
set -e

if test "$(uname -s)" != "Linux"; then
	echo "[ERROR] Not working on current OS"
	exit 2
fi

sudo dpkg --add-architecture i386

cd /tmp
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
rm winehq.key

sudo add-apt-repository -y ppa:cybermax-dexter/sdl2-backport
wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | sudo apt-key add -    
echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04 ./" | sudo tee /etc/apt/sources.list.d/wine-obs.list

echo "deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main" | sudo tee /etc/apt/sources.list.d/wine.list
sudo apt update
sudo apt install --install-recommends winehq-stable

