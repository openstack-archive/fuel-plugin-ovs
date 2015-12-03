#!/bin/bash

set -eux
rm -rf /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/
mkdir /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/
cd /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/;wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk-install/dpdk-2.1.0.tar.gz;tar -xvzf dpdk-2.1.0.tar.gz
cd /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/dpdk-2.1.0; make install T=x86_64-native-linuxapp-gcc
