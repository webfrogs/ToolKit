#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

echo "Configuring zsh..."
# Install or update oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "  Downloading oh-my-zsh."
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
	echo "  Updating oh-my-zsh."
	cd "$HOME/.oh-my-zsh"
	git submodule update --init --recursive
	cd "${ShellFolderPath}"
fi


if [[ -f "$HOME/.zshrc" ]]; then
	rm "$HOME/.zshrc"
fi
if [[ -L "$HOME/.zshrc" ]]; then
	rm "$HOME/.zshrc"
fi
ln -s "${ShellFolderPath}/_zshrc" "$HOME/.zshrc"


ZshCustomCompletionFolderPath=$HOME/.oh-my-zsh/custom/plugins/carl
if [[ -d "${ZshCustomCompletionFolderPath}" ]]; then
	rm -rf "${ZshCustomCompletionFolderPath}"
fi
if [[ -L "${ZshCustomCompletionFolderPath}" ]]; then
	rm "${ZshCustomCompletionFolderPath}"
fi

ln -s "${ShellFolderPath}/customCompletions" "${ZshCustomCompletionFolderPath}"



ZshCustomThemeFolderPath=$HOME/.oh-my-zsh/custom/themes
if [[ -d "${ZshCustomThemeFolderPath}" ]]; then
	rm -rf "${ZshCustomThemeFolderPath}"
fi
if [[ -L "${ZshCustomThemeFolderPath}" ]]; then
	rm "${ZshCustomThemeFolderPath}"
fi
ln -s "${ShellFolderPath}/customThemes" "${ZshCustomThemeFolderPath}"


echo "Configure zsh successfully.\nRun 'sudo chsh -s /bin/zsh' to change the default shell to zsh.\n"


