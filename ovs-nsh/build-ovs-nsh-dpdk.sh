#!/bin/bash

cd /openvswitch-dpdk;sed -i "s/2.4.90-1/2.4.91-1/" debian/changelog;sed -i "s?configure --with-linux?configure --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc --with-linux?" debian/dkms.conf.in;sed -i "s?configure --with-linux?configure --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc --with-linux?" debian/rules.modules;sed -i "s?configure --?configure -- --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc?" debian/rules;make dist;tar -xzf openvswitch-2.4.90.tar.gz;
cd /openvswitch-dpdk/openvswitch-2.4.90;DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary


