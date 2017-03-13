#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
deb_arch=$(dpkg --print-architecture)

if [ $nsh = 'true' ]; then
    ovs="ovs-nsh_${deb_arch}.tar.gz"
    apt-get install -y --allow-unauthenticated dkms
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/${ovs} | tar -xzv
    dpkg -i openvswitch-datapath-dkms_*.deb
    dpkg -i openvswitch-common_*.deb
    dpkg -i openvswitch-switch_*.deb
    dpkg -i python-openvswitch_*.deb
fi

rm -rf $INSTALL_HOME
