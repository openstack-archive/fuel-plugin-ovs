#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
dpdk=$3

wget -r -nd -np http://$host:8080/plugins/fuel-plugin-ovs-0.9/ovs_package/ubuntu

if [ $nsh = 'true' ]
then
    dpkg -i openvswitch-datapath-dkms_2.5.90-1_all.deb
    dpkg -i openvswitch-common_2.5.90-1_amd64.deb
    dpkg -i openvswitch-switch_2.5.90-1_amd64.deb
    if [ $dpdk = 'true' ]
    then
        dpkg -i openvswitch-switch-dpdk_2.5.90-1_amd64.deb
    fi
fi
