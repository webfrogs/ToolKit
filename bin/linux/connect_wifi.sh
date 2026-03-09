#!/bin/bash
set -e

if test "$1" = ""; then
  echo "ERROR. usage: ./bin/linux/connect_wifi.sh 'wifi_name'"
  exit 1
fi

sudo nmcli --ask device wifi connect "$1"
