#!/bin/sh

set -e
ShellFolderPath=$(cd $(dirname $0) && pwd)

PreferenceFilename="Preferences.sublime-settings"


case "$(uname -s)" in
	Darwin)
		AppUserPreferenceFilePath="$HOME/Library/Application Support/Sublime Text 3/Packages/User/${PreferenceFilename}"
		;;
	*)
		echo "Only support macOS for now."
		exit 1
esac

if [[ -f "${AppUserPreferenceFilePath}" ]]; then
	rm "${AppUserPreferenceFilePath}"
fi
if [[ -L "${AppUserPreferenceFilePath}" ]]; then
	rm "${AppUserPreferenceFilePath}"
fi
ln -s "${ShellFolderPath}/${PreferenceFilename}" "${AppUserPreferenceFilePath}"



