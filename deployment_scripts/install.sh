#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME 
cd $INSTALL_HOME 

host=$1
option=$2

wget -r -nd -np http://$host:8080/plugins/fuel-plugin-ovs-0.9/ovs_package/ubuntu

if [ $option = 'nshdpdk' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.nshdpdk-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.nshdpdk-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.nshdpdk-1_amd64.deb 
elif [ $option  = 'nsh' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.nsh-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.nsh-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.nsh-1_amd64.deb 
elif [ $option = 'dpdk' ]
then
    dpkg -i openvswitch-datapath-dkms_2.4.90.dpdk-1_all.deb 
    dpkg -i openvswitch-common_2.4.90.dpdk-1_amd64.deb 
    dpkg -i openvswitch-switch_2.4.90.dpdk-1_amd64.deb 
fi
