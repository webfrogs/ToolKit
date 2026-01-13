#!/bin/bash
set -e

if test "$(uname -s)" != "Linux"; then
  echo "Unsupported OS, only Linux."
  exit 1
fi

if test -x "$(command -v pacman)"; then
  sudo pacman -Syy
  sudo pacman -S --noconfirm \
    docker-compose
  docker compose version
  exit
fi

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

GithubReleaseURL="https://github.com/docker/compose/releases"
downloadJSON LATEST_RELEASE "${GithubReleaseURL}/latest"
LATEST_RELEASE_TAG=$(echo "${LATEST_RELEASE}" | tr -s '\n' ' ' | sed 's/.*"tag_name":"//' | sed 's/".*//' )
echo "Latest release tag: $LATEST_RELEASE_TAG"
sudo curl -L ${GithubReleaseURL}/download/${LATEST_RELEASE_TAG}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

/usr/bin/docker-compose --version
