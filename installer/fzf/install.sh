#!/bin/bash
set -e

InstallationPath=$HOME/.fzf
if [ -d "${InstallationPath}" ]; then
    echo "Fzf is already installed."
    exit 0
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ${InstallationPath}
${InstallationPath}/install --all
