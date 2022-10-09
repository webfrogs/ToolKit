#!/bin/bash
set -e

if test ! -x "$(command -v zsh)"; then
  echo "[ERROR] zsh is not installed."
  exit 2
fi

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

OhMyZshPath="$HOME/.config/oh-my-zsh"
OhMyZshCustomPath="$OhMyZshPath/custom"
mkdir -p $(dirname $OhMyZshPath)

# install autojump
if test ! -x "$(command -v autojump)"; then
  case "$(uname -s)" in
    Darwin)
      brew install autojump
      ;;
    Linux)
      if test -x "$(command -v yay)"; then
        yay -Ss autojump
      elif test -x "$(command -v apt-get)"; then
        sudo apt-get install -y autojump
      else
        echo "[ERROR] Unsupported package management"
        exit 2
      fi
      ;;
    *)
      echo "[ERROR] Unsupported OS"
      exit 2
      ;;
  esac
fi

# Install or update oh-my-zsh
if [ ! -d "$OhMyZshPath" ]; then
	echo "[INFO] Downloading oh-my-zsh..."
	git clone https://github.com/robbyrussell/oh-my-zsh.git "$OhMyZshPath"
else
  echo "[INFO] Updating oh-my-zsh..."
  cd "$OhMyZshPath"
  git fetch origin
  git reset --hard origin/master
	cd "${ShellFolderPath}"
fi

ln -sf "${ShellFolderPath}/_zshrc" "$HOME/.zshrc"

ZshCustomCompletionFolderPath=$OhMyZshCustomPath/plugins/carl
if test -d "${ZshCustomCompletionFolderPath}"; then
  rm -rf "${ZshCustomCompletionFolderPath}"
fi
ln -sf "${ShellFolderPath}/customCompletions" "${ZshCustomCompletionFolderPath}"

#zsh plugins
# zsh-autosuggestions
autosuggestionsPluginPath=$OhMyZshCustomPath/plugins/zsh-autosuggestions
if test -d "$autosuggestionsPluginPath"; then
  cd $autosuggestionsPluginPath
  git fetch origin
  git reset --hard origin/master
  cd $ShellFolderPath
else
  git clone https://github.com/zsh-users/zsh-autosuggestions $autosuggestionsPluginPath
fi

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

echo "[INFO] zsh is installed successfully."
