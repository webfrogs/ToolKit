#!/bin/bash
set -e

cd $(dirname $0)
ShellPath=$(pwd)

export NVM_DIR="$HOME/.nvm"
if test ! -e "${NVM_DIR}/nvm.sh"; then
  echo "==> nvm is not found, install it..."
  mkdir -p $HOME/.nvm
  curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh -o /tmp/install_nvm.sh
  bash /tmp/install_nvm.sh
  zshrc="${ZDOTDIR:+${ZDOTDIR}/.zshrc}"
  zshrc="${zshrc:-${HOME}/.zshrc}"
  if test -e "${zshrc}"; then
    echo "found zshrc path: ${zshrc}"
    echo "clear content added by nvm install script."
    sed -i '/$NVM_DIR\/bash_completion/d' ${zshrc}
  fi
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default lts/*

echo "==> check node version"
node -v

npm install -g yarn

echo "==> nodejs is installed successfully."
echo "Run 'source $NVM_DIR/nvm.sh' to use node immediately"
