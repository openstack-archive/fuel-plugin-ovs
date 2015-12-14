#!/bin/bash
set -eux

INSTALL_HOME=/usr/share/ovs/
sudo rm -rf $INSTALL_HOME ; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-datapath-dkms_2.4.90-1_all.deb
sudo dpkg -i openvswitch-datapath-dkms_2.4.90-1_all.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-common_2.4.90-1_amd64.deb
sudo dpkg -i openvswitch-common_2.4.90-1_amd64.deb
wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/openvswitch-switch_2.4.90-1_amd64.deb
sudo dpkg -i openvswitch-switch_2.4.90-1_amd64.deb
