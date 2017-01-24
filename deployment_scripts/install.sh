#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
dpdk=$3

apt-get install -y --allow-unauthenticated dkms

if [ $nsh = 'true' ]
then
    # support ovs with nsh/dpdk later
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/ovs-nsh-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.6.1-1.nsh_all.deb
    dpkg -i openvswitch-common_2.6.1-1.nsh_amd64.deb
    dpkg -i openvswitch-switch_2.6.1-1.nsh_amd64.deb
    dpkg -i python-openvswitch_2.6.1-1.nsh_all.deb
else
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/ovs-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.6.2-1.fuel10_all.deb
    dpkg -i openvswitch-common_2.6.2-1.fuel10_amd64.deb
    dpkg -i openvswitch-switch_2.6.2-1.fuel10_amd64.deb
    dpkg -i python-openvswitch_2.6.2-1.fuel10_all.deb
    if [ $dpdk = 'true' ]
    then
        apt-get install -y --allow-unauthenticated dpdk dpdk-dev dpdk-dkms
        dpkg -i openvswitch-switch-dpdk_2.6.2-1.fuel10_amd64.deb
    fi
fi
