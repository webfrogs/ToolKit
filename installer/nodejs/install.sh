#!/bin/sh
set -e

if test -x "$(command -v node)"; then
	echo "===> Nodejs has been installed."
	exit
fi

echo "===> Nodejs installing..."
if test -x "$(command -v apt-get)"; then
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
	echo "deb https://deb.nodesource.com/node_12.x bionic main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	echo "deb-src https://deb.nodesource.com/node_12.x bionic main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
	sudo apt-get update -y
	sudo apt-get install -y nodejs
else
	echo "ERROR! Installation is not supported for current OS."
	exit 2
fi

echo "===> Nodejs is installed successfully"

