#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "Xcode configuration start..."
case "$(uname -s)" in
	Darwin)
		SnippetsFolderPath="$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
		if [[ -d "${SnippetsFolderPath}" ]]; then
			rm -rf "${SnippetsFolderPath}"
		fi
		if [[ -L "${SnippetsFolderPath}" ]]; then
			rm "${SnippetsFolderPath}"
		fi
		ln -s "${ShellFolderPath}/CodeSnippets" "${SnippetsFolderPath}"
		;;
	*)
		echo "Only support macOS for now."
		exit 1
esac
echo "Xcode configuration end.\n"

