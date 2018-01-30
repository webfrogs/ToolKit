#!/bin/sh

set -e
ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


IosevkaDownloadURL="https://github.com/be5invis/Iosevka/releases/download/v1.13.4/iosevka-ss08-1.13.4.zip"

case "$(uname -s)" in
	Darwin)
		;;
	*)
		echo "Only support macOS for now."
		exit 1
esac

if [[ -d temp ]]; then
	rm -rf temp
fi
mkdir temp
cd temp

wget "${IosevkaDownloadURL}" -O iosevka.zip
unzip iosevka.zip
cp ttf/* "$HOME/Library/Fonts"

cd ..
rm -rf temp




