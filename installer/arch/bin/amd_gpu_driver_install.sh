#!/bin/sh
set -e

if test $1 = "--lib32"; then
  sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
else
  sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon
fi

