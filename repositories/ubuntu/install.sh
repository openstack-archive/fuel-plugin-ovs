#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME 
cd $INSTALL_HOME 

wget -r -nd -np http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu

if [ $1 = 'nshdpdk' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.nshdpdk-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.nshdpdk-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.nshdpdk-1_amd64.deb 
elif [ $1 = 'nsh' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.nsh-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.nsh-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.nsh-1_amd64.deb 
elif [ $1 = 'dpdk' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.dpdk-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.dpdk-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.dpdk-1_amd64.deb 
fi
