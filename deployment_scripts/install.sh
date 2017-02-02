#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

nsh=$1
dpdk=$2
deb_arch=$(dpkg --print-architecture)

ovs="ovs-dpdk_${deb_arch}.tar.gz"
if [ $nsh = 'true' ]; then
    ovs="ovs-nsh_${deb_arch}.tar.gz"
fi

apt-get install -y --allow-unauthenticated dkms

curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/${ovs} | tar -xzv
dpkg -i openvswitch-datapath-dkms_*.deb
dpkg -i openvswitch-common_*.deb
dpkg -i openvswitch-switch_*.deb
dpkg -i python-openvswitch_*.deb

if [ $dpdk = 'true' ]
then
    apt-get install -y --allow-unauthenticated dpdk dpdk-dev dpdk-dkms
    dpkg -i openvswitch-switch-dpdk_*.deb
fi

rm -rf $INSTALL_HOME
