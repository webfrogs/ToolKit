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
        if test -x "$(command -v apt-get)"; then
          if test "$(grep '^ID' /etc/os-release | cut -d= -f2)" == "debian"; then
            # debian
            # Add Docker's official GPG key:
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            # Add the repository to Apt sources:
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
          else
            # ubuntu
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

            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            dockerCeRepoAddress="deb [arch=amd64] https://download.docker.com/linux/ubuntu ${ubuntuCodeName} stable"
            echo "${dockerCeRepoAddress}" \
              | sudo tee /etc/apt/sources.list.d/docker-ce-${ubuntuCodeName}.list >/dev/null
            
            sudo apt-get update
            sudo apt-get install -y docker-ce
          fi
        elif test -x "$(command -v yum)"; then
            sudo yum install -y yum-utils \
                device-mapper-persistent-data \
                lvm2
            sudo yum-config-manager \
                --add-repo \
                https://download.docker.com/linux/centos/docker-ce.repo
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

