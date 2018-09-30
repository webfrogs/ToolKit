#!/bin/sh
set -e

ShellFolderPath=$( cd "$( dirname "$0" )" && pwd )
cd "${ShellFolderPath}"
ConfigFolderPath="${ShellFolderPath}/configs"

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
		brew install --HEAD universal-ctags/universal-ctags/universal-ctags

        $(brew --prefix)/opt/fzf/install --all
        ;;
    Linux)
		if command -v git >/dev/null 2>&1; then 
  			echo 'Git already exist.' 
		else 
  			echo "Git not exist. Install git first."
			exit 1
		fi

        if command -v apt-get >/dev/null 2>&1; then
	        sudo apt-get update
	        sudo apt-get -y install build-essential automake autoconf pkg-config vim cmake python python-dev golang-go zsh
        fi

        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        ;;
esac

git submodule update --init --recursive
#------


# Fonts installation ------
#./configs/fonts/Iosevka-installer.sh
#------

# zsh config ------
./configs/zsh/zsh-configer.sh
#------

# Vim config ------
./configs/vim/ctags-installer.sh
./configs/vim/vim-configer.sh
#------

# git config ------
./configs/git/git-configer.sh
#------


# Xcode config ------
case "$(uname -s)" in
	Darwin)
		echo "\nSetting Xcode..."
		xc_snippets_path=~/Library/Developer/Xcode/UserData/CodeSnippets
		if [[ -d $xc_snippets_path ]]; then
			rm -rf $xc_snippets_path
		fi
		if [[ -L $xc_snippets_path ]]; then
			rm $xc_snippets_path
		fi
		ln -s ${ConfigFolderPath}/xcode/CodeSnippets $xc_snippets_path
		echo "Done Xcode."
esac
#------


echo "\nAll Done. Change current shell to zsh by command 'chsh -s /bin/zsh'"


