#!/bin/sh
set -e

case "$(uname -s)" in
	Darwin)
		;;
	Linux)
    cd /tmp
    rm -rf aws
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
		;;
	*)
		echo "[ERROR] Unsupported OS"
		exit 2
		;;
esac


