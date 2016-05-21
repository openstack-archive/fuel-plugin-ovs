#!/bin/bash
set -eux

INSTALL_HOME=/usr/share/ovs/
rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
OVS_VER='2.5.90'
cd $INSTALL_HOME
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-datapath-dkms_${OVS_VER}-1_all.deb"
dpkg -i "openvswitch-datapath-dkms_${OVS_VER}-1_all.deb"
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-common_${OVS_VER}-1_amd64.deb"
dpkg -i "openvswitch-common_${OVS_VER}-1_amd64.deb"
wget "http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-switch_${OVS_VER}-1_amd64.deb"
dpkg -i "openvswitch-switch_${OVS_VER}-1_amd64.deb"
