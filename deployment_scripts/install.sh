#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

nsh=$1

apt-get install -y --allow-unauthenticated dkms

if [ $nsh = 'true' ]
then
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/ovs-nsh-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.6.1-1.nsh_all.deb
    dpkg -i openvswitch-common_2.6.1-1.nsh_amd64.deb
    dpkg -i openvswitch-switch_2.6.1-1.nsh_amd64.deb
    dpkg -i python-openvswitch_2.6.1-1.nsh_all.deb
fi
