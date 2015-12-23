#!/bin/bash

NICS=$1
INSTALL_HOME=/usr/share/dpdk/
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk-2.1.0.bin.tar.gz
tar xzvf dpdk-2.1.0.bin.tar.gz
rm -rf dpdk-2.1.0.bin.tar.gz
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.init -O /etc/init.d/dpdk
chmod +x /etc/init.d/dpdk
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.conf -O /etc/default/dpdk.conf
sed "s/DPDK_NIC_MAPPINGS=.*/DPDK_NIC_MAPPINGS=${NICS}/" -i /etc/default/dpdk.conf
service dpdk start

INSTALL_HOME=/usr/share/ovs-dpdk/
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-datapath-dkms_2.4.90-1_all.deb
dpkg -i openvswitch-datapath-dkms_2.4.90-1_all.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-common_2.4.90-1_amd64.deb
dpkg -i openvswitch-common_2.4.90-1_amd64.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-switch_2.4.90-1_amd64.deb
dpkg -i openvswitch-switch_2.4.90-1_amd64.deb
