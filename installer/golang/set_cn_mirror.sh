#!/bin/sh
set -e

go env -w GOPROXY=https://goproxy.io,direct
