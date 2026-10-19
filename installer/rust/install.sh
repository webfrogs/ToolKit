#!/bin/sh
set -e

use_cn_mirror=true
for arg in "$@"; do
  case "$arg" in
    --no-cn-mirror)
      use_cn_mirror=false
      ;;
  esac
done

if test "$use_cn_mirror" = true; then
  export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
  export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
fi

if test -x "$(command -v pacman)"; then
  sudo pacman -Syy
  sudo pacman -S --noconfirm rustup
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

rustup default stable
rustup update
