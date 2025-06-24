#!/bin/sh
set -e

if test "$(whoami)" != "root"; then
	echo "===> Error! Shell must be executed by root."
	exit 1
fi

wgClientFolder=/etc/wireguard/clients

read -p "New client name: " newClient
if test -d "${wgClientFolder}/${newClient}"; then
	echo "===> Error. '${newClient}' already exists."
	exit 1
fi

wgServerIP=$(cat /etc/wireguard/server/wg.conf | grep '^WG_SERVER_ADDRESS' | awk -F= '{print $2}')
if test -z "$wgServerIP"; then
  echo "ERROR! no wg server ip found."
  exit 1
fi
wgClientIPPrefix="${wgServerIP%.*}"

mkdir -p ${wgClientFolder}/${newClient}
wg genkey | tee ${wgClientFolder}/${newClient}/privatekey | wg pubkey > ${wgClientFolder}/${newClient}/publickey

if test ! -f "${wgClientFolder}/nextPtr"; then
  echo -n "2" > ${wgClientFolder}/nextPtr
fi

ipPtr=$(cat ${wgClientFolder}/nextPtr)
cat <<EOF | sudo tee ${wgClientFolder}/${newClient}/wg.conf
CLIENT_IP=${wgClientIPPrefix}.${ipPtr}
EOF
nextPtr=$(expr ${ipPtr} + 1)
echo -n "${nextPtr}" > ${wgClientFolder}/nextPtr

echo "===> Client keys is generated in '${wgClientFolder}/${newClient}'"
