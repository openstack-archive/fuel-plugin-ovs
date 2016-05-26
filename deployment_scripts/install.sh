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
    wget  -r -np -nH --cut-dirs=3 http://$host:8080/plugins/fuel-plugin-ovs-0.9/ovs-nsh/
    dpkg -i openvswitch-datapath-dkms_2.5.90-1_all.deb
    dpkg -i openvswitch-common_2.5.90-1_amd64.deb
    dpkg -i openvswitch-switch_2.5.90-1_amd64.deb
    dpkg -i python-openvswitch_2.5.90-1_all.deb
    if [ $dpdk = 'true' ]
    then
        dpkg -i libxenstore3.0_4.4.2-0ubuntu0.14.04.5_amd64.deb
        dpkg -i libdpdk0_2.2.0-1_amd64.deb
        dpkg -i dpdk_2.2.0-1_amd64.deb
        dpkg -i openvswitch-switch-dpdk_2.5.90-1_amd64.deb
    fi
elif [ $dpdk = 'true' ]
then
    wget  -r -np -nH --cut-dirs=3 http://$host:8080/plugins/fuel-plugin-ovs-0.9/ovs-dpdk/
    dpkg -i libxenstore3.0_4.4.2-0ubuntu0.14.04.5_amd64.deb
    dpkg -i libdpdk0_2.2.0-1_amd64.deb
    dpkg -i dpdk_2.2.0-1_amd64.deb
    dpkg -i openvswitch-datapath-dkms_2.5.1-1_all.deb
    dpkg -i openvswitch-common_2.5.1-1_amd64.deb
    dpkg -i openvswitch-switch_2.5.1-1_amd64.deb
    dpkg -i python-openvswitch_2.5.1-1_all.deb
    dpkg -i openvswitch-switch-dpdk_2.5.1-1_amd64.deb
fi
