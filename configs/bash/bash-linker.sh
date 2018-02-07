#!/bin/sh
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"


echo "Bash configuration start..."
case "$(uname -s)" in
	Darwin)
		if [[ -f "${HOME}/.bash_profile" ]]; then
			rm "${HOME}/.bash_profile"
		fi
		if [[ -L "${HOME}/.bash_profile" ]]; then
			rm "${HOME}/.bash_profile"
		fi
		ln -s "${ShellFolderPath}/_bash_profile" "${HOME}/.bash_profile"
		;;
	*)
		;;
esac
echo "Bash configuration end.\n"

