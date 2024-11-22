#!/bin/bash
set -e

echo "[INFO] Installing docker..."

if test -x "$(command -v docker)"; then
    echo "[INFO] docker is already been installed."
    exit
fi

case "$(uname -s)" in
    Darwin)
        echo "[INFO] Please install Docker for mac manually."
        exit
        ;;
    Linux)
        read -p "Use mirror repo of China? [y/n]: " chinaMirror
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

            ubuntuCodeName=$(lsb_release -cs)
            if test -f "/etc/lsb-release"; then
                distribID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F"=" '{ print $2 }')
                if test ${distribID} = "LinuxMint"; then
                    ubuntuCodeName=$(grep "UBUNTU_CODENAME" /etc/os-release | awk -F"=" '{ print $2 }')
                fi
            fi

            if test "${chinaMirror}" = "y"; then
              sudo mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu ${ubuntuCodeName} stable" \
                | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            else
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              dockerCeRepoAddress="deb [arch=amd64] https://download.docker.com/linux/ubuntu ${ubuntuCodeName} stable"
              echo "${dockerCeRepoAddress}" \
                | sudo tee /etc/apt/sources.list.d/docker-ce-${ubuntuCodeName}.list >/dev/null
            fi
            
            sudo apt-get update
            sudo apt-get install -y docker-ce
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
            sudo yum install -y docker-ce
        elif test -x "$(command -v pacman)"; then
          sudo pacman -Syy docker docker-buildx docker-compose --noconfirm
        else
            echo "[ERROR] Can not find support package management."
            exit 1
        fi

        sudo systemctl start docker
        sudo systemctl enable docker
        ;;
    *)
        echo "Unsupported OS is found."
        exit 1
        ;;
esac

