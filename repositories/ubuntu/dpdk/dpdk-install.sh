#!/bin/bash

NICS=$1
INSTALL_HOME=/usr/share/dpdk/
OVS_VER='2.5.90'
DPDK_VER='2.2.0'
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk-${DPDK_VER}.bin.tar.gz"
tar xzvf "dpdk-${DPDK_VER}.bin.tar.gz"
rm -rf dpdk-${DPDK_VER}.bin.tar.gz
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.init -O /etc/init.d/dpdk
chmod +x /etc/init.d/dpdk
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.conf -O /etc/default/dpdk.conf
sed "s/DPDK_NIC_MAPPINGS=.*/DPDK_NIC_MAPPINGS=${NICS}/" -i /etc/default/dpdk.conf
service dpdk start

INSTALL_HOME=/usr/share/ovs-dpdk/
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-datapath-dkms_${OVS_VER}-1_all.deb"
dpkg -i "openvswitch-datapath-dkms_${OVS_VER}_all.deb"
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-common_${OVS_VER}-1_amd64.deb"
dpkg -i "openvswitch-common_${OVS_VER}-1_amd64.deb"
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/openvswitch-switch_${OVS_VER}-1_amd64.deb"
dpkg -i "openvswitch-switch_${OVS_VER}-1_amd64.deb"
