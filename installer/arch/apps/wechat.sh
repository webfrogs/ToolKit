#!/bin/sh
set -e

yay -S wechat-bin --noconfirm

# sudo tee /usr/local/bin/wechat >/dev/null <<'EOF'
# #!/bin/sh
# set -e 

# trashAppUnsafe=1 /usr/bin/wechat-uos-qt
# EOF

# sudo chmod +x /usr/local/bin/wechat
