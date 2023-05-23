#!/bin/bash
set -e

for autojumplib in $(ls /usr/lib/python3.11/site-packages | grep '^auto'); do
  sudo ln -sf /usr/lib/python3.11/site-packages/${autojumplib} /usr/lib/python3.10/site-packages/${autojumplib}
done

echo "Done."
