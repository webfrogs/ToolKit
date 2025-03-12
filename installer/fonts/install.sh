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

scp -P 6666 -r res@sftp.webfrog.top:font/carl_fonts.txz /tmp/carl_fonts.txz
tar xvJf /tmp/carl_fonts.txz -C /tmp

cp /tmp/carl_fonts/*.ttf "$fontDir"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

rm -rf /tmp/carl_fonts.txz
rm -rf /tmp/carl_fonts 



