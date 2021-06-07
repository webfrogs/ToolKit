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
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

            ubuntuCodeName=$(lsb_release -cs)
            if test -f "/etc/lsb-release"; then
                distribID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F"=" '{ print $2 }')
                if test ${distribID} = "LinuxMint"; then
                    ubuntuCodeName=$(grep "UBUNTU_CODENAME" /etc/os-release | awk -F"=" '{ print $2 }')
                fi
            fi

            if test "${chinaMirror}" = "y"; then
                dockerCeRepoAddress="deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
                    ${ubuntuCodeName} stable"
            else
                dockerCeRepoAddress="deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                    ${ubuntuCodeName} stable"
            fi

            echo "${dockerCeRepoAddress}" \
                | sudo tee /etc/apt/sources.list.d/docker-ce-${ubuntuCodeName}.list >/dev/null
            
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
            sudo yum install -y docker-ce docker-ce-cli containerd.io
        elif test -x "$(command -v pacman)"; then
	    sudo pacman -Syy docker --noconfirm
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

