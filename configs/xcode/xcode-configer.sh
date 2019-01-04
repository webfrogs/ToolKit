#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

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
esac

