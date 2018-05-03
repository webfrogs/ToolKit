#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


case "$(uname -s)" in
    Darwin)
        echo "Use homebrew to install ctags: 'brew install --HEAD universal-ctags/universal-ctags/universal-ctags'"
        exit
        ;;
    Linux)
    	cd /tmp
    	if [ -d "ctags" ]; then
    		rm -rf ctags
    	fi
    	git clone https://github.com/universal-ctags/ctags.git
		cd ctags
		./autogen.sh
		./configure
		make
		sudo make install

		cd ..
		rm -rf ctags
        ;;
    *)
        echo "Found unsupported OS."
        exit 1
        ;;
esac
