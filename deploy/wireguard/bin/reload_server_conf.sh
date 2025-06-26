#!/bin/sh
set -e

if test "$(whoami)" != "root"; then
	echo "===> Error! Shell must be executed by root."
	exit 1
fi

wgClientFolder=/etc/wireguard/clients
wgServerFolder=/etc/wireguard/server





