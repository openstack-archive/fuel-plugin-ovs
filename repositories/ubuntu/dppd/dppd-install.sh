#!/bin/bash
set -eux
INSTALL_HOME=/usr/share/dppd/
sudo rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
sudo apt-get install -y pkg-config unzip liblua5.2-dev libpcap-dev libedit-dev libncurses5-dev libncursesw5-dev
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dppd/dppd-prox-v021.zip;
unzip dppd-prox-v021.zip
export RTE_SDK=/usr/share/dpdk/dpdk-2.1.0
export RTE_TARGET=x86_64-native-linuxapp-gcc
cd /usr/share/dppd/dppd-PROX-v021
export DPPD_DIR=`pwd`; make
