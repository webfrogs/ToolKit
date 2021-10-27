#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test "$(uname -s)" != "Darwin"; then
  echo "==> [ERROR] Current OS is not macOS"
  exit 2
fi

if ! test -x "$(command -v brew)"; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
if ! test -x "$(command -v git)"; then
  echo "==> [ERROR] Git not exist."
  echo "Try 'xcode-select --install' to install Xcode Command Line Tools."
  exit 1
fi

echo "==> [INFO] Installing necessary software..."
brew install cmake wget cloc fzf go
$(brew --prefix)/opt/fzf/install --all

./configs/zsh/config.sh
./configs/git/config.sh

echo "==> [INFO] All finished."







