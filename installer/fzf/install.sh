#!/bin/bash
set -e

case "$(uname -s)" in
    Darwin)
        brew install fzf
        $(brew --prefix)/opt/fzf/install --all
        ;;
    Linux)
        InstallationPath=$HOME/.fzf
        if [ -d "${InstallationPath}" ]; then
            echo "Fzf is already installed."
            exit 0
        fi

        git clone --depth 1 https://github.com/junegunn/fzf.git ${InstallationPath}
        ${InstallationPath}/install --all
        ;;
    *)
        echo "Unsupported OS is found."
        exit 1
        ;;
esac

