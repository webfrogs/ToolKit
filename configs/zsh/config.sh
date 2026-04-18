#!/bin/bash
set -e

if test ! -x "$(command -v zsh)"; then
  echo "[ERROR] zsh is not installed."
  exit 1
fi

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

# Install starship if not present
if ! command -v starship &> /dev/null; then
  echo "[INFO] Installing starship..."
  if command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm starship
  elif command -v apt &> /dev/null; then
    sudo apt install -y starship
  else
    echo "[WARN] No supported package manager found, skipping starship installation."
  fi
fi
# Install zoxide if not present
if ! command -v zoxide &> /dev/null; then
  echo "[INFO] Installing zoxide..."
  if command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm zoxide
  elif command -v apt &> /dev/null; then
    sudo apt install -y zoxide
  else
    echo "[WARN] No supported package manager found, skipping zoxide installation."
  fi
fi
# Install atuin if not present
if ! command -v atuin &> /dev/null; then
  echo "[INFO] Installing atuin..."
  if command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm atuin
  elif command -v cargo &> /dev/null; then
    cargo install atuin
  else
    echo "[WARN] No supported package manager found, skipping atuin installation."
  fi
fi

ln -sf "${ShellFolderPath}/conf" "$HOME/.config/zsh" 
cat > ~/.zshenv << 'ZSHENV'
# Zsh config directory
export ZDOTDIR="$HOME/.config/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
ZSHENV


if test $(basename $SHELL) != "zsh"; then
  echo ""
  read -p "Zsh is not default shell, set it as default? [y/n]: " shouldSetDefault
  if [ ! "${shouldSetDefault}" == "y" ]; then
      shouldSetDefault=""
  fi
  if test "${shouldSetDefault}" = "y"; then
    chsh -s $(which zsh)
  fi
fi
echo "==> zsh configuration done."
