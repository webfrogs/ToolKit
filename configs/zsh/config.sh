#!/bin/bash
set -e

if test ! -x "$(command -v zsh)"; then
  echo "[ERROR] zsh is not installed."
  exit 2
fi

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

OhMyZshPath="$HOME/.config/oh-my-zsh"
mkdir -p $(dirname $OhMyZshPath)

# Install or update oh-my-zsh
if [ ! -d "$OhMyZshPath" ]; then
	echo "[INFO] Downloading oh-my-zsh..."
	git clone https://github.com/robbyrussell/oh-my-zsh.git "$OhMyZshPath"
else
  echo "[INFO] Updating oh-my-zsh..."
  cd "$OhMyZshPath"
	git submodule update --init --recursive
	cd "${ShellFolderPath}"
fi

ln -sf "${ShellFolderPath}/_zshrc" "$HOME/.zshrc"

ZshCustomCompletionFolderPath=$OhMyZshPath/custom/plugins/carl
if [[ -d "${ZshCustomCompletionFolderPath}" ]]; then
	rm -rf "${ZshCustomCompletionFolderPath}"
fi
if [[ -L "${ZshCustomCompletionFolderPath}" ]]; then
	rm "${ZshCustomCompletionFolderPath}"
fi
ln -s "${ShellFolderPath}/customCompletions" "${ZshCustomCompletionFolderPath}"


#ZshCustomThemeFolderPath=$OhMyZshPath/custom/themes
#BulletTrainThemeFolderPath="${ZshCustomThemeFolderPath}/bullet-train-oh-my-zsh-theme"
#if [[ -d "${BulletTrainThemeFolderPath}" ]]; then
#	rm -rf "${BulletTrainThemeFolderPath}"
#fi
#if [[ -L "${BulletTrainThemeFolderPath}" ]]; then
#	rm "${BulletTrainThemeFolderPath}"
#fi
#ln -s "${ShellFolderPath}/customThemes/bullet-train-oh-my-zsh-theme" "${BulletTrainThemeFolderPath}"

echo ""
read -p "Set zsh as default shell? [y/n]: " shouldSetDefault
if [ ! "${shouldSetDefault}" == "y" ]; then
    shouldSetDefault=""
fi
if test "${shouldSetDefault}" = "y"; then
  chsh -s $(which zsh)
fi

echo "[INFO] zsh is installed successfully."
