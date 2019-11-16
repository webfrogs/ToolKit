#!/bin/sh
set -e

if test -x "$(command -v go)"; then
	echo "[Info] Golang already exists."
	exit
fi

case "$(uname -s)" in
	Darwin)
		brew install go
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
			sudo add-apt-repository -y ppa:longsleep/golang-backports
			sudo apt-get update
			sudo apt-get -y install golang-go
		elif test -x "$(command -v yum)"; then
			echo "Not support yet."
			exit 2
		else
			echo "[Error] No package management tools found."
			exit 1
		fi
		;;
	*)
		echo "Unsupported OS is found."
		exit 1
		;;
esac
