#!/bin/sh
set -e

yay -S --noconfirm discord_arch_electron

sudo tee /usr/local/bin/run_discord <<EOF
#!/bin/sh
set -e

export https_proxy='http://127.0.0.1:1090'

exec /usr/bin/discord
EOF

sudo chmod +x /usr/local/bin/run_discord

