#!/bin/bash
set -eux

INSTALL_HOME=/tmp/ovs-nshdpdk
dpdk=$1
dpdk_socket_mem=${2:-''}
pmd_cpu_mask=${3:-'2'}

if [ $dpdk = 'true' ]
then
    #Set to 0, dpdk init script mount hugepages but don't change current allocation
    sed -i "s/[# ]*\(NR_2M_PAGES=\).*/\10/" /etc/dpdk/dpdk.conf
    service dpdk restart

    ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
    ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="$dpdk_socket_mem"
    ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask="$pmd_cpu_mask"

    service openvswitch-switch restart
fi
