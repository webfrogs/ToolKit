#!/bin/bash
set -e
set -o pipefail

currentPath=$(pwd)

if test ! -f ".smb.env"; then
  read -p "input smb username: " smbUser
  read -p "input smb password: " smbPwd
  cat <<EOF | tee .smb.env > /dev/null
SMB_USER=${smbUser}
SMB_PWD=${smbPwd}
EOF
fi

source .smb.env

echo "==> samba server deploy info:"
echo "  deploy path: ${currentPath}"
echo "    data path: ${currentPath}/data"
echo " smb username: ${SMB_USER}"

echo ""
read -p "Confirm? [y/n]: " InfoConfirm
if test "${InfoConfirm}" != "y"; then
  echo "Maybe next time, see you."
  exit 1
fi

docker rm -f samba_server
# https://github.com/dperson/samba
docker run -d --name=samba_server \
  --restart=always \
  -e TZ=Asia/Shanghai \
  -p 139:139 -p 445:445 \
  -v ${currentPath}/data:/share \
  dperson/samba:latest -p \
  -u "${SMB_USER};${SMB_PWD}" \
  -s "share;/share;yes;no;no;all;${SMB_USER};${SMB_USER}"


# docker volume create --driver local --opt type=cifs --opt device=//192.168.110.104/share --opt o=username=carl,password=xxxxxx smb_share
