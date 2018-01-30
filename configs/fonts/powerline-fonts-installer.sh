#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

FontsDownloadFolderName="powerlineFonts"
if [[ -d "${FontsDownloadFolderName}" ]]; then
	rm -rf "${FontsDownloadFolderName}"
fi
echo $"Downloading powerline fonts."
git clone https://github.com/powerline/fonts.git "${FontsDownloadFolderName}"
cd "${FontsDownloadFolderName}"
./install.sh
cd ..
rm -rf "${FontsDownloadFolderName}"

