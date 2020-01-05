#!/bin/sh
set -e

cd $(dirname $0)

if test -x "$(command -v nvim)"; then
	echo "===> Neovim has been installed."
	exit
fi

# check nodejs installation
../nodejs/install.sh

echo "===> Installing neovim..."
if test -x "$(command -v apt-get)"; then
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt-get update -y
	sudo apt-get install -y neovim
else
	echo "ERROR! Installation is not support for current OS"
	exit 2
fi

echo "===> Neovim is installed successfully."
