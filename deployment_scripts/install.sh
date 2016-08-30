#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
rm -rf $INSTALL_HOME; mkdir -p $INSTALL_HOME
cd $INSTALL_HOME

host=$1
nsh=$2
dpdk=$3
if [ $dpdk = 'true' ];then
    dpdk_socket_mem=$4
fi



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
        dpkg -i libdpdk0_16.07-1_amd64.deb
        dpkg -i dpdk_16.07-1_amd64.deb
        dpkg -i openvswitch-switch-dpdk_2.5.90-1_amd64.deb

        dpdk_pages=$(($dpdk_socket_mem / 2))
        sed "s/#*\(NR_2M_PAGES=\).*/\1${dpdk_pages}/" /etc/dpdk/dpdk.conf
        service dpdk start

        ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
        [ -n $dpdk_socket_mem ] && vs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="$dpdk_socket_mem"

        service openvswitch-switch restart
    fi
fi
