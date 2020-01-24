#!/bin/sh
set -e 

if test -x "$(command -v brew)"; then
	echo "[Info] homebrew is already installed."
	exit
fi

case "$(uname -s)" in
	Darwin)
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		;;
	Linux)
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
		;;
	*)
		echo "[Error] Unsupported OS"
		exit 2
		;;
esac
