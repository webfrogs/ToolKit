#!/bin/sh
set -e

cd $(dirname $0)

# opencode
paru -S opencode-bin
bunx oh-my-opencode install

# gemini-cli
npm install -g @google/gemini-cli
gemini extensions install https://github.com/github/github-mcp-server
# ../bin/aur_install.sh 

