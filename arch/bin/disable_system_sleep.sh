#!/bin/sh
set -e

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
