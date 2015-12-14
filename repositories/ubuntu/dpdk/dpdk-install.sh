#!/bin/bash
set -eux

INSTALL_HOME=/usr/share/dpdk/
sudo rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk-2.1.0.tar.gz;
tar -xvzf dpdk-2.1.0.tar.gz
cd $INSTALL_HOME/dpdk-2.1.0; make install T=x86_64-native-linuxapp-gcc

