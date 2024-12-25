#!/bin/sh
set -e

case "$(uname -s)" in
	Darwin)
    cd /tmp
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
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

echo "Done. run 'aws configure' to set credentials"


