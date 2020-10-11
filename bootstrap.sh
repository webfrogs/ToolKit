#!/bin/sh
set -e

ShellFolderPath=$( cd "$( dirname "$0" )" && pwd )
cd "${ShellFolderPath}"
ConfigFolderPath="${ShellFolderPath}/configs"

case "$(uname -s)" in
	Darwin)
		if ! test -x "$(command -v git)"; then
			echo "[Error] Git not exist."
			echo "  Try 'xcode-select --install' to install Xcode Command Line Tools."
			exit 1
		fi
		if ! test -x "$(command -v brew)"; then
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi

		echo "[Info] Installing necessary software..."
		brew install cmake wget cloc fzf go
		$(brew --prefix)/opt/fzf/install --all

		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
			sudo apt-get update
			sudo apt-get -y install \
				git build-essential automake autoconf resolvconf \
				pkg-config vim cmake python python-dev zsh
		elif test -x "$(command -v yum)"; then
			sudo yum update
			sudo yum install -y \
				git vim zsh
		elif test -x "$(command -v pacman)"; then
			sudo pacman -Syy git vim zsh
		else
			echo "[Error] No package management tools found."
			exit 2
		fi

		if [ ! -d "$HOME/.fzf" ]; then
			git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
			$HOME/.fzf/install --all
		fi

		;;
	*)
		echo "[Error] Unsupported OS"
		exit 2
		;;
esac

./configs/git/git-configer.sh
git submodule update --init --recursive
./configs/zsh/zsh-configer.sh

echo "[Info] All finished."
