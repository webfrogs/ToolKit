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

#ZshCustomThemeFolderPath=$OhMyZshPath/custom/themes
#BulletTrainThemeFolderPath="${ZshCustomThemeFolderPath}/bullet-train-oh-my-zsh-theme"
#if [[ -d "${BulletTrainThemeFolderPath}" ]]; then
#	rm -rf "${BulletTrainThemeFolderPath}"
#fi
#if [[ -L "${BulletTrainThemeFolderPath}" ]]; then
#	rm "${BulletTrainThemeFolderPath}"
#fi
#ln -s "${ShellFolderPath}/customThemes/bullet-train-oh-my-zsh-theme" "${BulletTrainThemeFolderPath}"

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
