#!/bin/sh
set -e

sudo mkdir -p /.snapshots
sudo btrfs subvolume snapshot -r / /.snapshots/root_backup_$(date +%Y%m%d)
