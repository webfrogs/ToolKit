#!/bin/bash
set -e

cd $(dirname $0)
current_user=$(whoami)

echo "${current_user} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${current_user}
sudo chmod 440 /etc/sudoers.d/${current_user}

echo "All done. Now '${current_user}' can run sudo without passwd"
