#!/bin/bash
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
        read -p "Need China mirror? [y/n]: " chinaMirror
        if [ ! "${chinaMirror}" == "y" ]; then
            chinaMirror=""
        fi

        if test -x "$(command -v apt-get)"; then
            sudo apt-get update
            sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg2 \
                software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            if [ -z "${chinaMirror}" ]; then
                sudo add-apt-repository \
                    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                    $(lsb_release -cs) \
                    stable"
            else
                sudo add-apt-repository \
                    "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
                    bionic stable"
            fi
            sudo apt-get update
            sudo apt-get install -y docker-ce
            sudo systemctl start docker
        elif test -x "$(command -v yum)"; then
            sudo yum install -y yum-utils \
                device-mapper-persistent-data \
                lvm2
            if [ -z "${chinaMirror}" ]; then 
                sudo yum-config-manager \
                    --add-repo \
                    https://download.docker.com/linux/centos/docker-ce.repo
            else
                sudo wget -O /etc/yum.repos.d/docker-ce.repo \
                    https://download.docker.com/linux/centos/docker-ce.repo
                sudo sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
                sudo yum makecache fast
            fi
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
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

