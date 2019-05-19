#!/bin/sh
set -e

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
ubuntu-drivers devices

echo "Install nvidia driver using 'sudo apt install nvidia-driver-[version].'"
echo "Check driver using 'nvidia-smi' after reboot if install finished."