#!/bin/sh
set -e

cd $(dirname $0)

if test ! -x "$(command -v node)"; then
	echo "[ERROR] node is not found, install it first. Try to run './installer/nodejs/install.sh'"
	exit 2
fi

npm install -g neovim

echo "===> Installing neovim..."
case "$(uname -s)" in
  Darwin)
    brew install neovim ripgrep fd
    ;;
  Linux)
    if test -x "$(command -v pacman)"; then
      sudo pacman -Syy
      sudo pacman -S neovim xsel ripgrep fd python-pip python-pynvim --noconfirm
    elif test -x "$(command -v apt)"; then
      sudo apt install -y neovim python3-pip xsel ripgrep
    else
      echo "[ERROR] Installation script does not support current OS"
      exit 2
    fi
    ;;
  *)
    echo "[ERROR] Unsupported OS"
    exit 2
    ;;
esac

# install necessary python module
if test -x "$(command -v python3)" -a ! -x "$(command -v pacman)"; then
  python3 -m pip install --user --upgrade pynvim
fi

echo "===> Installing neovim config"
rm -rf ${HOME}/.config/nvim
git clone git@github.com:webfrogs/nvim.git ${HOME}/.config/nvim

echo "===> Neovim is installed successfully."
