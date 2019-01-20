#!/bin/sh
set -e 

if ! test -x "$(command -v gem)"; then
    echo "[Error] Command 'gem' is not found"
    exit 1
fi

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/

