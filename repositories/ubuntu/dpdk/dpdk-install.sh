#!/bin/bash

NICS=$1
INSTALL_HOME=/usr/share/dpdk/
sudo rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk-2.1.0.tar.gz;
tar -xvzf dpdk-2.1.0.tar.gz
cd $INSTALL_HOME/dpdk-2.1.0; make install T=x86_64-native-linuxapp-gcc
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.init -O /etc/init.d/dpdk
chmod +x /etc/init.d/dpdk
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.conf -O /etc/default/dpdk.conf
sed "s/DPDK_NIC_MAPPINGS=.*/DPDK_NIC_MAPPINGS=${NICS}/" -i /etc/default/dpdk.conf
sudo service dpdk start
INSTALL_HOME=/usr/share/ovs-dpdk/
sudo rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-datapath-dkms_2.4.90-1_all.deb
sudo dpkg -i openvswitch-datapath-dkms_2.4.90-1_all.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-common_2.4.90-1_amd64.deb
sudo dpkg -i openvswitch-common_2.4.90-1_amd64.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-switch_2.4.90-1_amd64.deb
sudo dpkg -i openvswitch-switch_2.4.90-1_amd64.deb
