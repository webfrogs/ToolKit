#!/bin/sh
set -e

cd $(dirname $0)

if test "$(whoami)" != "root"; then
	echo "===> Error! Shell must be executed by root."
	exit 1
fi

rm -rf /etc/wireguard/bin
mkdir -p /etc/wireguard
ln -sf $(pwd)/bin /etc/wireguard/bin

wgServerConfigFolder=/etc/wireguard/server
if test -f "${wgServerConfigFolder}/privatekey" -a -f "${wgServerConfigFolder}/publickey"; then
	echo "===> OK! Found wireguard server keys."
else
  mkdir -p ${wgServerConfigFolder}
  wg genkey | tee ${wgServerConfigFolder}/privatekey | wg pubkey | tee ${wgServerConfigFolder}/publickey
fi

wgServerConf=${wgServerConfigFolder}/wg.conf
if test ! -f "${wgServerConf}"; then
  echo "===> No server config, ready to create."
  read -p "input wg server address: " wgServerAddress
  if echo "$wgServerAddress" | grep -vq '\.1$'; then
    echo "ERROR! server address must has suffix '.1'"
    exit 1
  fi
  read -p "input wg server listen port: " wgServerPort
  echo ""
  echo "wg server config"
  echo " address: ${wgServerAddress}"
  echo " listen port: ${wgServerPort}"
  read -p "Confirm? [y/n]: " InfoConfirm
  if test "${InfoConfirm}" = "y"; then
    cat <<EOF | sudo tee ${wgServerConf}
WG_SERVER_ADDRESS=${wgServerAddress}
WG_SERVER_PORT=${wgServerPort}
EOF
  fi
else
  echo "===> Found server config at path ${wgServerConf}:"
  cat ${wgServerConf}
fi

