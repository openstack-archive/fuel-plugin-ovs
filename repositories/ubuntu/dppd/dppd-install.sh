#!/bin/bash
set -eux
INSTALL_HOME=/usr/share/dppd/
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
apt-get install -y pkg-config liblua5.2-dev libpcap-dev libedit-dev libncurses5-dev libncursesw5-dev
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dppd/dppd-prox-v021.bin.tar.gz
tar xzvf dppd-prox-v021.bin.tar.gz
rm -rf dppd-prox-v021.bin.tar.gz
