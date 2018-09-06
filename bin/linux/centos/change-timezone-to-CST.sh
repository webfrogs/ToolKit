#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

timedatectl set-timezone Asia/Shanghai

echo "Success."
