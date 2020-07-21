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
if test -x "$(command -v apt)"; then
	sudo apt install neovim
else
	echo "ERROR! Installation script does not support current OS"
	exit 2
fi

echo "===> Neovim is installed successfully."

echo "===> Installing neovim config"
git clone git@github.com:webfrogs/nvim.git ${HOME}/.config/nvim
