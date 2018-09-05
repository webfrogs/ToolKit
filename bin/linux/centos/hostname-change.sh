#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

if [ $# != 1 ]; then
    echo "Usage: $(basename $0) <hostname>"
    exit 1
fi

echo $1 > /etc/hostname
hostname $1

