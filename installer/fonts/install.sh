#!/bin/bash
set -e

case "$(uname -s)" in
	Darwin)
        fontDir="$HOME/Library/Fonts"
		;;
    Linux*)
        fontDir="$HOME/.local/share/fonts"
        ;;
	*)
		echo "Found os which is not support."
		exit 1
esac

if test ! -d "$fontDir"; then
    mkdir -p $fontDir
fi

curl -Lfk -o /tmp/my_fonts.txz https://myfile.webfrog.top:6443/font/my_fonts.txz -H 'Authorization: Basic bm9ib2R5OmlhbW5vYm9keQ=='

cp ttf/* "$fontDir"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

rm -rf /tmp/my_fonts.txz



