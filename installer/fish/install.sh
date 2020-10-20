#!/bin/bash
set -e

cd $(dirname $0)
workDir=$(pwd)


case "$(uname -s)" in
	Darwin)
    echo "[ERROR] macOS installation is not supported"
    exit 2
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
			echo "[ERROR] apt-get is not supported yet."
      exit 2
		elif test -x "$(command -v yum)"; then
			echo "[ERROR] yum is not supported yet."
			exit 2
		elif test -x "$(command -v pacman)"; then
      sudo pacman -Syy fish
      curl -L https://get.oh-my.fish | fish
		else
			echo "[ERROR] No supported package management tools."
			exit 2
		fi
		;;
	*)
		echo "[ERROR] Unsupported OS is found."
		exit 2
		;;
esac

# install theme bobthefish
echo "omf install bobthefish" | fish

echo "[INFO] fish is installed successfully."
echo "Use command 'chsh -s $(which fish)' to set fish as default shell."
