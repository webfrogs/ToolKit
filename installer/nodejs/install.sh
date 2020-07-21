#!/bin/sh
set -e

if test -x "$(command -v node)"; then
	echo "===> Nodejs has been installed."
	exit
fi

curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o /tmp/install_nvm.sh
bash /tmp/install_nvm.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 12.18.2
nvm use 12.18.2

node -v

npm install -g yarn

echo "[INFO] nodejs is installed successfully."

