#!/bin/sh
set -e

watch -n 1 "sudo netstat -n | awk '/^tcp/ {++S[\$NF]} END {for(a in S) print a, S[a]}'"
