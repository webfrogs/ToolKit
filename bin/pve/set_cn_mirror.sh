#!/bin/bash
set -e

# doc: https://zhuanlan.zhihu.com/p/1937263770503186125

source /etc/os-release

if test "${ID}" != "debian"; then
  echo "ERROR! not debian"
  exit 1
fi

if test "${VERSION_ID}" != "13"; then
  echo "ERROR! only support debian 13, current: ${VERSION_ID}"
  exit 1
fi

sudo rm -f /etc/apt/sources.list.d/pve-enterprise.sources
sudo rm -f /etc/apt/sources.list.d/ceph.sources

cat <<EOF | sudo tee /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: trixie trixie-updates
Components: main contrib non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main contrib non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

cat <<EOF | sudo tee /etc/apt/sources.list.d/ceph.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/ceph-squid
Suites: trixie
Components: no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

cat <<EOF | sudo tee pve-no-subscription.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

# LXC cn mirror. restart to make it work
sudo cp /usr/share/perl5/PVE/APLInfo.pm /usr/share/perl5/PVE/APLInfo.pm_back
sudo sed -i 's|http://download.proxmox.com|https://mirrors.tuna.tsinghua.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm

# remove subscription alert on webUI
sudo sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && sudo systemctl restart pveproxy.service
