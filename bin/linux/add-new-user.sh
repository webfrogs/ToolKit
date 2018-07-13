#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

read -p "Enter new username: " newUsername
if [ -z "${newUsername}" ]; then
    echo "Error! Username can not be empty."
    exit 1
fi
read -p "Enter ${newUsername}'s ssh public key: " sshPublicKey
if [ -z "${sshPublicKey}" ]; then
    echo "Error! SSH public key can not be empty."
    exit 1
fi

adduser ${newUsername}

su - ${newUsername} <<END_USER
cd ~
mkdir .ssh
cd .ssh
echo ${sshPublicKey} >> authorized_keys
chmod 600 authorized_keys
chmod 700 ~/.ssh
END_USER

echo "'${newUsername}' has been created successfully."
read -p "Give root permissions to '${newUsername}'? [y/n] " rootPermission
if [ "${rootPermission}" == "y" ]; then
    usermod -g wheel ${newUsername}
    echo "${newUsername} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${newUsername}
    chmod 440 /etc/sudoers.d/${newUsername}
    echo "Done. Now '${newUsername}' has root permissions."
fi

echo "All done."