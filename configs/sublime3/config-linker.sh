#!/bin/bash

set -e
ShellFolderPath=$(cd $(dirname $0) && pwd)

PreferenceFilename="Preferences.sublime-settings"

SelfPreferenceFilename="Preferences.sublime-settings"
case "$(uname -s)" in
	Darwin)
		AppUserPreferenceFilePath="$HOME/Library/Application Support/Sublime Text 3/Packages/User/${PreferenceFilename}"
		;;
	Linux)
		AppUserPreferenceFilePath="$HOME/.config/sublime-text-3/Packages/User/${PreferenceFilename}"
		SelfPreferenceFilename="Preferences-linuxmint.sublime-settings"
		;;
	*)
		echo "Found unsupported OS."
		exit 1
esac

if [[ -f "${AppUserPreferenceFilePath}" ]]; then
	rm "${AppUserPreferenceFilePath}"
fi
if [[ -L "${AppUserPreferenceFilePath}" ]]; then
	rm "${AppUserPreferenceFilePath}"
fi
ln -s "${ShellFolderPath}/${SelfPreferenceFilename}" "${AppUserPreferenceFilePath}"



