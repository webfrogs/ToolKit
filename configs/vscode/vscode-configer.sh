#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "VS Code configuration start..."
VSCodeSettingFilePath="${HOME}/Library/Application Support/Code/User/settings.json"
if [[ -f "${VSCodeSettingFilePath}" ]]; then
	rm "${VSCodeSettingFilePath}"
fi
if [[ -L "${VSCodeSettingFilePath}" ]]; then
	rm "${VSCodeSettingFilePath}"
fi
ln -s "${ShellFolderPath}/settings.json" "${VSCodeSettingFilePath}"

VSCodeKeybindingFilePath="${HOME}/Library/Application Support/Code/User/keybindings.json"
if [[ -f "${VSCodeKeybindingFilePath}" ]]; then
	rm "${VSCodeKeybindingFilePath}"
fi
if [[ -L "${VSCodeKeybindingFilePath}" ]]; then
	rm "${VSCodeKeybindingFilePath}"
fi
ln -s "${ShellFolderPath}/keybindings.json" "${VSCodeKeybindingFilePath}"

echo "VS Code configuration end.\n"

