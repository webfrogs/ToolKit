#!/bin/sh
set -e

cd $(dirname $0)
ShellPath=$(pwd)

if test ! -x "$(command -v nvm)"; then
  echo "==> nvm is not found, install it..."
  mkdir -p $HOME/.nvm
  curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh -o /tmp/install_nvm.sh
  export NVM_DIR="$HOME/.nvm"
  bash /tmp/install_nvm.sh
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi


nvm install v22.16.0
nvm use v22.16.0
nvm alias default 22.16.0

echo "==> check node version"
node -v

npm install -g yarn

echo "==> nodejs is installed successfully."
echo "Run 'source $NVM_DIR/nvm.sh' to use node immediately"
