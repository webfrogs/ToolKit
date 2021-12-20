#!/bin/bash
set -e

for autojumplib in $(ls /usr/lib/python3.10/site-packages | grep '^auto'); do
  sudo ln -s /usr/lib/python3.10/site-packages/${autojumplib} /usr/lib/python3.9/site-packages/${autojumplib}
done

echo "Done."
