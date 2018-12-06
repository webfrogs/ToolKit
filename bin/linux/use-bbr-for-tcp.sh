#!/bin/bash
set -e

if [ ! "$(uname -s)" == "Linux" ]; then
    echo "[Error] Only support linux."
    exit 1
fi

if [ ! `whoami` == "root" ]; then
    echo "[Error] Shell should be executed by root."
    exit 1
fi

OLD_IFS="$IFS" 
IFS=" = " 
tcpControlSplitData=($(sysctl net.ipv4.tcp_congestion_control))
IFS="$OLD_IFS"
currentTcpControl=${tcpControlSplitData[1]}

if [ "${currentTcpControl}" = "bbr"  ]; then
    echo "[Info] current tcp congestion control is already bbr"
    exit 0
fi

# install bbr module
modprobe tcp_bbr
echo "tcp_bbr" | tee -a /etc/modules-load.d/modules.conf

# use bbr
echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf
sysctl -p

# test
sysctl net.ipv4.tcp_congestion_control

echo "Done."