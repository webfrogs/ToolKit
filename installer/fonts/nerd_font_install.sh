#!/bin/bash
set -e

ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

FontName=$1
if test -z "${FontName}"; then
  echo "error! usage: ./nerd_font_install.sh [font name]"
  exit 2
fi

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

if [ ! -d "$fontDir" ]; then
    mkdir -p $fontDir
fi


GITHUB_RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases"

downloadJSON() {
    url="$2"

    echo "Fetching $url.."
    if test -x "$(command -v curl)"; then
        response=$(curl -s -L -w 'HTTPSTATUS:%{http_code}' -H 'Accept: application/json' "$url")
        body=$(echo "$response" | sed -e 's/HTTPSTATUS\:.*//g')
        code=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    elif test -x "$(command -v wget)"; then
        temp=$(mktemp)
        body=$(wget -q --header='Accept: application/json' -O - --server-response "$url" 2> "$temp")
        code=$(awk '/^  HTTP/{print $2}' < "$temp" | tail -1)
        rm "$temp"
    else
        echo "Neither curl nor wget was available to perform http requests."
        exit 1
    fi
    if [ "$code" != 200 ]; then
        echo "Request failed with code $code"
        exit 1
    fi

    eval "$1='$body'"
}

downloadFile() {
    url="$1"
    destination="$2"

    echo "Fetching $url"
    if test -x "$(command -v curl)"; then
        code=$(curl -s -w '%{http_code}' -L "$url" -o "$destination")
    elif test -x "$(command -v wget)"; then
        code=$(wget -q -O "$destination" --server-response "$url" 2>&1 | awk '/^  HTTP/{print $2}' | tail -1)
    else
        echo "Neither curl nor wget was available to perform http requests."
        exit 1
    fi

    if [ "$code" != 200 ]; then
        echo "Request failed with code $code"
        exit 1
    fi
}

if [[ -d temp ]]; then
	rm -rf temp
fi
mkdir temp
cd temp


downloadJSON LATEST_RELEASE "${GITHUB_RELEASE_URL}/latest"
GITHUB_RELEASE_TAG=$(echo "${LATEST_RELEASE}" | tr -s '\n' ' ' | sed 's/.*"tag_name":"//' | sed 's/".*//' )
echo "Latest Release Tag = $GITHUB_RELEASE_TAG"
# GITHUB_VERSION=${GITHUB_RELEASE_TAG:1}

# fetch the real release data to make sure it exists before we attempt a download
downloadJSON RELEASE_DATA "$GITHUB_RELEASE_URL/tag/$GITHUB_RELEASE_TAG"

GITHUB_ZIP_FILE_URL="$GITHUB_RELEASE_URL/download/$GITHUB_RELEASE_TAG/${FontName}.zip"

GITHUB_ZIP_FILENAME="${FontName}.zip"
downloadFile "$GITHUB_ZIP_FILE_URL" "$(pwd)/${GITHUB_ZIP_FILENAME}"

mkdir ${FontName}
unzip ${GITHUB_ZIP_FILENAME} -d ${FontName}
cp ${FontName}/* "$fontDir"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

cd ..
rm -rf temp




