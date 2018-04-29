#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "Git configuration start..."
if [[ -f "$HOME/.gitconfig" ]]; then
	rm "$HOME/.gitconfig"
fi
if [[ -L "$HOME/.gitconfig" ]]; then
	rm "$HOME/.gitconfig"
fi
ln -s "${ShellFolderPath}/_gitconfig" "$HOME/.gitconfig"
echo "Git configuration end.\n"

