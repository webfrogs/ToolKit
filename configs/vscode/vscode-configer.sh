#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

case "$(uname -s)" in
    Darwin)
        VSCodeConfigPath="$HOME/Library/Application Support/Code"
        ;;
    Linux)
        VSCodeConfigPath="$HOME/.config/Code"
        ;;
    *)
        echo "Error: unsupported OS."
        exit 1
        ;;
esac

echo "VS Code configuration start..."
VSCodeSettingFilePath="${VSCodeConfigPath}/User/settings.json"
if [[ -f "${VSCodeSettingFilePath}" ]]; then
	rm "${VSCodeSettingFilePath}"
fi
if [[ -L "${VSCodeSettingFilePath}" ]]; then
	rm "${VSCodeSettingFilePath}"
fi
mkdir -p $(dirname ${VSCodeSettingFilePath})
ln -s "${ShellFolderPath}/settings.json" "${VSCodeSettingFilePath}"

VSCodeKeybindingFilePath="${VSCodeConfigPath}/User/keybindings.json"
if [[ -f "${VSCodeKeybindingFilePath}" ]]; then
	rm "${VSCodeKeybindingFilePath}"
fi
if [[ -L "${VSCodeKeybindingFilePath}" ]]; then
	rm "${VSCodeKeybindingFilePath}"
fi
mkdir -p $(dirname ${VSCodeKeybindingFilePath})
ln -s "${ShellFolderPath}/keybindings.json" "${VSCodeKeybindingFilePath}"

VSCodeSnippitsFolderPath="${VSCodeConfigPath}/User/snippets"
if [[ -d "${VSCodeSnippitsFolderPath}" ]]; then
    rm -rf "${VSCodeSnippitsFolderPath}"
fi
if [[ -L "${VSCodeSnippitsFolderPath}" ]]; then
    rm "${VSCodeSnippitsFolderPath}"
fi
mkdir -p $(dirname ${VSCodeSnippitsFolderPath})
ln -s "${ShellFolderPath}/snippets" "${VSCodeSnippitsFolderPath}"

echo "VS Code configuration end."

