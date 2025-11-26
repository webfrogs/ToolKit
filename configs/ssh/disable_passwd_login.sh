#!/bin/sh
set -e

cd $(dirname $0)

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-$(date +'%Y%m%d')

sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
echo 'PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config

sudo systemctl restart sshd

