#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

if test -x "$(command -v ctags)"; then
	echo "[Info] ctags is already installed."
	exit
fi

echo "[Info] Installing ctags..."
case "$(uname -s)" in
    Darwin)
		brew install --HEAD universal-ctags/universal-ctags/universal-ctags
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
        echo "[Error] Found unsupported OS."
        exit 1
        ;;
esac

echo "[Info] ctags is installed successfully."
