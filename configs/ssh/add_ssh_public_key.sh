#!/bin/sh
set -e

cd $(dirname $0)

if test -f "${HOME}/.ssh/authorized_keys"; then
	rm -f "${HOME}/.ssh/authorized_keys.bak"
	mv "${HOME}/.ssh/authorized_keys" "${HOME}/.ssh/authorized_keys.bak"
	echo "===> Backup current authorized_keys to ${HOME}/.ssh/authorized_keys.bak"
fi

ln -sf $(pwd)/authorized_keys ${HOME}/.ssh/authorized_keys
