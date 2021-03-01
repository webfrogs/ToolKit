#!/bin/sh
set -e

if test ! -d "${HOME}/.cargo"; then
	echo "ERROR! cargo folder is not exist."
	exit 2
fi

cat << EOF > ${HOME}/.cargo/config
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
EOF

