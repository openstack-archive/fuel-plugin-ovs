#!/bin/bash

set -eux
sudo apt-get install -y pkg-config unzip liblua5.2-dev libpcap-dev libedit-dev libncurses5-dev libncursesw5-dev
rm -rf /etc/fuel/plugins/fuel-plugin-ovs-0.5/dppd-install/
mkdir /etc/fuel/plugins/fuel-plugin-ovs-0.5/dppd-install/
cd /etc/fuel/plugins/fuel-plugin-ovs-0.5/dppd-install/;wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dppd-install/dppd-prox-v021.zip;unzip dppd-prox-v021.zip
export RTE_SDK=/etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/dpdk-2.1.0
export RTE_TARGET=x86_64-native-linuxapp-gcc
cd /etc/fuel/plugins/fuel-plugin-ovs-0.5/dppd-install/dppd-PROX-v021
export DPPD_DIR=`pwd`
make
