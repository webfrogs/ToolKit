#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "Configuring vim..."
if [[ -f "$HOME/.vimrc" ]]; then
	rm "$HOME/.vimrc"
fi
ln -sf "${ShellFolderPath}/_vimrc" "$HOME/.vimrc"

echo "Vim is ready.\n"

