#!/bin/sh
set -e

if test -x "$(command -v docker)"; then
    echo "[Info] docker is already been installed."
    exit
fi

case "$(uname -s)" in
    Darwin)
        echo "[Info] Please install Docker for mac manually."
        exit
        ;;
    Linux)
        if test -x "$(command -v apt-get)"; then
            sudo apt-get update
            sudo apt-get install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg2 \
                software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu bionic stable"
            sudo apt-get update
            sudo apt-get install docker-ce
        elif test -x "$(command -v yum)"; then
            echo "[Info] yum support is not implemented."
        else
            echo "[Error] Can not find support package management."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS is found."
        exit 1
        ;;
esac

