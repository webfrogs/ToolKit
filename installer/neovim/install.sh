#!/bin/sh
set -e

cd $(dirname $0)

if test ! -x "$(command -v node)"; then
	echo "[ERROR] node is not found. Install it first"
	exit 2
fi

echo "===> Installing neovim..."
case "$(uname -s)" in
  Darwin)
    brew install neovim
    ;;
  Linux)
    if test -x "$(command -v pacman)"; then
      sudo pacman -Syy neovim xsel ripgrep --noconfirm
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
if test -x "$(command -v python3)"; then
  python3 -m pip install --user --upgrade pynvim
fi

echo "===> Neovim is installed successfully."

echo "===> Installing neovim config"
rm -rf ${HOME}/.config/nvim
git clone git@github.com:webfrogs/nvim.git ${HOME}/.config/nvim


