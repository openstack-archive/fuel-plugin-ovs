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
experimental_ovs=$6

OVS_VER='2.5.90-1'
DPDK_VER='2.2.0-1'
NSH_TARBALL='ovs-nsh-dpdk'
if [ $experimental_ovs == 'true' ]
then
    OVS_VER='2.6.1-1'
    DPDK_VER='16.07-1'
    NSH_TARBALL='ovs-nsh-dpdk-2.6.1'
fi

if [ $nsh = 'true' ]
then
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/${NSH_TARBALL}.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_${OVS_VER}.nsh_all.deb
    dpkg -i openvswitch-common_${OVS_VER}.nsh_amd64.deb
    dpkg -i openvswitch-switch_${OVS_VER}.nsh_amd64.deb
    dpkg -i python-openvswitch_${OVS_VER}.nsh_all.deb
    if [ $dpdk = 'true' ]
    then
        dpkg -i libxenstore3.0*.deb
        dpkg -i libdpdk0_${DPDK_VER}_amd64.deb
        dpkg -i dpdk_${DPDK_VER}_amd64.deb
        dpkg -i openvswitch-switch-dpdk_${OVS_VER}.nsh_amd64.deb
    fi
else
    curl  http://$host:8080/plugins/fuel-plugin-ovs-1.0/repositories/ubuntu/ovs-dpdk.tar.gz | tar -xzv
    dpkg -i openvswitch-datapath-dkms_2.5.90-1_all.deb
    dpkg -i openvswitch-common_2.5.90-1_amd64.deb
    dpkg -i openvswitch-switch_2.5.90-1_amd64.deb
    dpkg -i python-openvswitch_2.5.90-1_all.deb
    if [[ $dpdk = 'true' && -n $dpdk_socket_mem ]]
    then
        dpkg -i libxenstore3.0*.deb
        dpkg -i libdpdk0_16.07-1_amd64.deb
        dpkg -i dpdk_16.07-1_amd64.deb
        dpkg -i openvswitch-switch-dpdk_2.5.90-1_amd64.deb

        #Set to 0, dpdk init script mount hugepages but don't change current allocation
        sed -i "s/[# ]*\(NR_2M_PAGES=\).*/\10/" /etc/dpdk/dpdk.conf
        service dpdk start

        ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
        ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="$dpdk_socket_mem"
        ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask="$pmd_cpu_mask"

        service openvswitch-switch restart
    fi
fi
