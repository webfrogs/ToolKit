#!/bin/sh

set -e
ShellFolderPath=$(cd $(dirname $0) && pwd)
cd "${ShellFolderPath}"

case "$(uname -s)" in
	Darwin)
		;;
	*)
		echo "Only support macOS for now."
		exit 1
esac


Iosevka_RELEASE_URL="https://github.com/be5invis/Iosevka/releases"

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

    echo "Fetching $url.."
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


downloadJSON LATEST_RELEASE "${Iosevka_RELEASE_URL}/latest"
Iosevka_RELEASE_TAG=$(echo "${LATEST_RELEASE}" | tr -s '\n' ' ' | sed 's/.*"tag_name":"//' | sed 's/".*//' )
echo "Latest Release Tag = $Iosevka_RELEASE_TAG"
Iosevka_VERSION=${Iosevka_RELEASE_TAG:1}

# fetch the real release data to make sure it exists before we attempt a download
downloadJSON RELEASE_DATA "$Iosevka_RELEASE_URL/tag/$Iosevka_RELEASE_TAG"

Iosevka_ZIP_FILE_URL="$Iosevka_RELEASE_URL/download/$Iosevka_RELEASE_TAG/iosevka-ss08-${Iosevka_VERSION}.zip"

Iosevka_ZIP_FILENAME="iosevka.zip"
downloadFile "$Iosevka_ZIP_FILE_URL" "$(pwd)/${Iosevka_ZIP_FILENAME}"

unzip iosevka.zip
cp ttf/* "$HOME/Library/Fonts"

cd ..
rm -rf temp




