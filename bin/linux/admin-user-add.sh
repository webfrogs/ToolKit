#!/bin/bash
set -e

cd $(dirname $0)

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

newUsername=carl

if test $(grep ^DISTRIB_ID= /etc/lsb-release 2>/dev/null | awk -F'=' '{ print $2 }') = "Ubuntu"; then
    adduser --disabled-password --gecos "" ${newUsername}
else
    adduser ${newUsername}
fi

mkdir -p /home/${newUsername}/.ssh
cp ../../configs/ssh/authorized_keys /home/${newUsername}/.ssh/
chown -R ${newUsername} /home/${newUsername}/.ssh
chmod 700 /home/${newUsername}/.ssh
chmod 600 /home/${newUsername}/.ssh/authorized_keys

echo "'${newUsername}' has been created successfully."

echo "${newUsername} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${newUsername}
chmod 440 /etc/sudoers.d/${newUsername}
echo "Done. Now '${newUsername}' has root permissions."

echo "All done."