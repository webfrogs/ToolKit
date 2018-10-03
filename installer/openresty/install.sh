#!/bin/bash
set -e

cd $(dirname $0)
TempFolderName="tmp"
if [ -d "${TempFolderName}" ]; then
    rm -rf "${TempFolderName}"
fi

case "$(uname -s)" in
    Darwin)
        brew install openresty/brew/openresty
        ;;
    Linux)
        if test -x "$(command -v apt-get)"; then
            sudo apt-get install -y libpcre3-dev libssl-dev perl make build-essential curl zlib1g-dev
        elif test -x "$(command -v yum)"; then
            sudo yum install -y pcre-devel openssl-devel gcc curl
        else
            echo "[Error] No supported package manager."
            exit 1
        fi

        mkdir "${TempFolderName}"
        cd "${TempFolderName}"

        OpenrestyVersion="1.13.6.2"
        wget "https://openresty.org/download/openresty-${OpenrestyVersion}.tar.gz"
        tar -xvzf openresty-${OpenrestyVersion}.tar.gz

        cd openresty-${OpenrestyVersion}
        ./configure -j2
        make -j2
        sudo make install
        cd ..

        cd ..
        rm -rf "${TempFolderName}"
        ;;
    *)
        echo "[Error] Found unsupported OS"
        exit 1
        ;;
esac
