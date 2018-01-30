#!/bin/sh
set -e

ShellFolderPath=$( cd "$( dirname "$0" )" && pwd )
cd "${ShellFolderPath}"


git submodule update --init --recursive


# Basic tools installation ------
case "$(uname -s)" in
	Darwin)
		if command -v git >/dev/null 2>&1; then 
  			echo 'Git already exist.' 
		else 
  			echo "Git not exist. Try 'xcode-select --install' to install Xcode Command Line Tools."
			exit 1
		fi

		if command -v brew >/dev/null 2>&1; then 
  			echo 'Homebrew has already been installed.' 
		else 
  			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi

		echo "\nInstall necessary tools for macOS..."
		brew install cmake wget cloc fzf go

        $(brew --prefix)/opt/fzf/install --all
esac

#------


# Fonts installation ------
./configs/fonts/Iosevka-installer.sh
#------

# zsh config ------
./configs/zsh/zsh-configer.sh
#------

# Vim config ------
./configs/vim/vim-configer.sh
#------




# git config ------
echo "\nSetting git..."
if [ -f ~/.gitconfig ]; then
	rm ~/.gitconfig
fi
ln -s ${Root_path}/git/_gitconfig ~/.gitconfig

echo "Done git."
#------


# Xcode config ------
case "$(uname -s)" in
	Darwin)
		echo "\nSetting Xcode..."
		xc_snippets_path=~/Library/Developer/Xcode/UserData/CodeSnippets
		if [ -d $xc_snippets_path ]; then
			rm -rf $xc_snippets_path
		fi
		ln -s ${Root_path}/xcode/CodeSnippets $xc_snippets_path
		echo "Done Xcode."
esac
#------


echo "\nAll Done. Change current shell to zsh by command 'chsh -s /bin/zsh'"


