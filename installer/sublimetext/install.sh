#!/bin/bash
set -e

cd $(dirname $0)
workDir=$(pwd)

PreferenceFilename="Preferences.sublime-settings"

configInstallPath="$HOME/.config/sublime-text-3/Packages/User/${PreferenceFilename}"
case "$(uname -s)" in
	Darwin)
    configInstallPath="$HOME/Library/Application Support/Sublime Text 3/Packages/User/${PreferenceFilename}"
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
      if grep -Fxq "[sublime-text]" /etc/pacman.conf; then
        echo "[INFO] sublimetext repository is configurated."
      else
        curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        echo "" | sudo tee -a /etc/pacman.conf
        echo "[sublime-text]" | sudo tee -a /etc/pacman.conf
        echo 'Server = https://download.sublimetext.com/arch/stable/x86_64' | sudo tee -a /etc/pacman.conf
      fi
      sudo pacman -Syy sublime-text
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


configFiles=($(ls ${workDir}/configs))

echo ""
echo "[INFO] choose config file to install"
echo "config file list:"
index=0
while test $index -lt ${#configFiles[@]}; do
  echo " $(expr $index + 1). ${configFiles[index]}"
  index=$(expr $index + 1)
done
read -p "Which one do you choose: " selectedIndex
if test $selectedIndex -lt 1 -o $selectedIndex -gt ${#configFiles[@]}; then
  echo "[ERROR] input is invalid."
  exit 2
fi

selectedConfigFilePath="${workDir}/configs/${configFiles[$(expr $selectedIndex - 1)]}"

if [[ -f "${configInstallPath}" ]]; then
	rm "${configInstallPath}"
fi

mkdir -p "$(dirname ${configInstallPath})"
ln -sf "${selectedConfigFilePath}" "${configInstallPath}"

echo "[INFO] sublimetext is installed successfully"
