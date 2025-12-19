#!/bin/sh
set -e

IS_ACTIVE_FLOATING="$(hyprctl activewindow -j 2>/dev/null | jq -r '.floating // false' 2>/dev/null)"
if test "$IS_ACTIVE_FLOATING" = "true"; then
  hyprctl dispatch cyclenext prev
elif test "$IS_ACTIVE_FLOATING" = "false"; then
  hyprctl dispatch cyclenext floating
fi
