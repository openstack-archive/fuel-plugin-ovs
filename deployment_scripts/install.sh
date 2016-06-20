#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
dpdk=$3


if [ $nsh = 'true' ]
then
    curl  http://$host:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu/ovs-nsh-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.5.90-1.nsh_all.deb
    dpkg -i openvswitch-common_2.5.90-1.nsh_amd64.deb
    dpkg -i openvswitch-switch_2.5.90-1.nsh_amd64.deb
    dpkg -i python-openvswitch_2.5.90-1.nsh_all.deb
    if [ $dpdk = 'true' ]
    then
        dpkg -i libxenstore3.0*.deb
        dpkg -i libdpdk0_2.2.0-1_amd64.deb
        dpkg -i dpdk_2.2.0-1_amd64.deb
        dpkg -i openvswitch-switch-dpdk_2.5.90-1.nsh_amd64.deb
    fi
else
    curl  http://$host:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu/ovs-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.5.90-1_all.deb
    dpkg -i openvswitch-common_2.5.90-1_amd64.deb
    dpkg -i openvswitch-switch_2.5.90-1_amd64.deb
    dpkg -i python-openvswitch_2.5.90-1_all.deb
    if [ $dpdk = 'true' ]
    then
        dpkg -i libxenstore3.0*.deb
        dpkg -i libdpdk0_16.04-1_amd64.deb
        dpkg -i dpdk_16.04-1_amd64.deb
        dpkg -i openvswitch-switch-dpdk_2.5.90-1_amd64.deb
    fi
fi
