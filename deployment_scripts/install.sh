#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
dpdk=$3
dpdk_socket_mem=${4:-''}
pmd_cpu_mask=${5:-'2'}

ovs="ovs-dpdk.tar.gz"
if [ $nsh = 'true' ]; then
    ovs="ovs-nsh-dpdk.tar.gz"
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

if [[ $dpdk = 'true' && -n $dpdk_socket_mem ]]
then
    #Set to 0, dpdk init script mount hugepages but don't change current allocation
    sed -i "s/[# ]*\(NR_2M_PAGES=\).*/\10/" /etc/dpdk/dpdk.conf
    service dpdk start

    ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
    ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="$dpdk_socket_mem"
    ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask="$pmd_cpu_mask"

    service openvswitch-switch restart
fi

rm -rf $INSTALL_HOME
