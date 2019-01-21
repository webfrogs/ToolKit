#!/bin/bash
set -e

if [ `whoami` == "root" ]; then
    echo "Hey, you are already root user, no need to do this."
    exit 1
fi

sudo gpasswd -a $USER docker
newgrp docker

echo "Done."
