#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "Configuring vim..."
if [[ -f "$HOME/.vimrc" ]]; then
	rm "$HOME/.vimrc"
fi
if [[ -L "$HOME/.vimrc" ]]; then
	rm "$HOME/.vimrc"
fi
ln -s "${ShellFolderPath}/_vimrc" "$HOME/.vimrc"

VimFolderPath="$HOME/.vim"
if [[ -d "${VimFolderPath}" ]]; then
	rm -rf "${VimFolderPath}"
fi
if [[ -L "${VimFolderPath}" ]]; then
	rm "${VimFolderPath}"
fi
ln -s "${ShellFolderPath}/_vim" "${VimFolderPath}"


vim +PlugInstall +qall

echo "Vim is ready.\n"

