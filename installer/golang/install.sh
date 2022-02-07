#!/bin/sh
set -e

if test -x "$(command -v go)"; then
	echo "[INFO] Golang already exists."
	exit
fi

case "$(uname -s)" in
	Darwin)
		brew install go
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
      sudo add-apt-repository ppa:longsleep/golang-backports
      sudo apt update
      sudo apt install -y golang-go
		elif test -x "$(command -v yum)"; then
			echo "Not support yet."
			exit 2
		else
			echo "[ERROR] No package management tools found."
			exit 1
		fi
		;;
	*)
		echo "Unsupported OS is found."
		exit 1
		;;
esac
