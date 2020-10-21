#!/bin/bash
set -e

cd $(dirname $0)
workDir=$(pwd)


case "$(uname -s)" in
	Darwin)
    echo "[ERROR] macOS installation is not supported"
    exit 2
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
			echo "[ERROR] apt-get is not supported yet."
      exit 2
		elif test -x "$(command -v yum)"; then
			echo "[ERROR] yum is not supported yet."
			exit 2
		elif test -x "$(command -v pacman)"; then
      if test ! -x "$(command -v fish)"; then
        sudo pacman -Syy fish
        curl -L https://get.oh-my.fish | fish
        # install theme bobthefish
        echo "omf install bobthefish" | fish
        # install fisher plugin manager
        curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
      fi
		else
			echo "[ERROR] No supported package management tools."
			exit 2
		fi
		;;
	*)
		echo "[ERROR] Unsupported OS is found."
		exit 2
		;;
esac

fisher add jorgebucaran/nvm.fish

omfConfigFilePath="${HOME}/.config/omf/init.fish"
if test -f "${omfConfigFilePath}"; then
  rm -f ${omfConfigFilePath}
fi
ln -sf ${workDir}/config/omf_init.fish ${omfConfigFilePath}

echo ""
read -p "Set fish as default shell? [y/n]: " shouldSetDefault
if [ ! "${shouldSetDefault}" == "y" ]; then
    shouldSetDefault=""
fi
if test "${shouldSetDefault}" = "y"; then
  chsh -s $(which fish)
fi

echo "[INFO] fish is installed successfully."
