#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

# Install or update oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "[Info] Downloading oh-my-zsh..."
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
	echo "[Info] Updating oh-my-zsh..."
	cd "$HOME/.oh-my-zsh"
	git submodule update --init --recursive
	cd "${ShellFolderPath}"
fi

ln -sf "${ShellFolderPath}/_zshrc" "$HOME/.zshrc"

ZshCustomCompletionFolderPath=$HOME/.oh-my-zsh/custom/plugins/carl
if [[ -d "${ZshCustomCompletionFolderPath}" ]]; then
	rm -rf "${ZshCustomCompletionFolderPath}"
fi
if [[ -L "${ZshCustomCompletionFolderPath}" ]]; then
	rm "${ZshCustomCompletionFolderPath}"
fi
ln -s "${ShellFolderPath}/customCompletions" "${ZshCustomCompletionFolderPath}"


ZshCustomThemeFolderPath=$HOME/.oh-my-zsh/custom/themes
BulletTrainThemeFolderPath="${ZshCustomThemeFolderPath}/bullet-train-oh-my-zsh-theme"
if [[ -d "${BulletTrainThemeFolderPath}" ]]; then
	rm -rf "${BulletTrainThemeFolderPath}"
fi
if [[ -L "${BulletTrainThemeFolderPath}" ]]; then
	rm "${BulletTrainThemeFolderPath}"
fi
ln -s "${ShellFolderPath}/customThemes/bullet-train-oh-my-zsh-theme" "${BulletTrainThemeFolderPath}"


echo "[Info] oh-my-zsh is set successfully."
echo "  Wanna use zsh as default? Run 'chsh -s $(which zsh)'"


