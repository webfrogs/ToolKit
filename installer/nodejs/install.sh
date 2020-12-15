#!/bin/sh
set -e

cd $(dirname $0)
ShellPath=$(pwd)

if test -x "$(command -v node)"; then
	echo "===> Nodejs has been installed."
	exit
fi

mkdir -p $HOME/.nvm

curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh -o /tmp/install_nvm.sh
export NVM_DIR="$HOME/.nvm"
bash /tmp/install_nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 12.18.2
nvm use 12.18.2

node -v

npm install -g yarn

read -p "set cn mirror? [y/n]: " chinaMirror
if test "${chinaMirror}" == "y"; then
  ${ShellPath}/set_cn_mirror.sh
fi

echo "[INFO] nodejs is installed successfully."
echo "Run 'source $NVM_DIR/nvm.sh' to use node immediately"

