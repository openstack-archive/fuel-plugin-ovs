#!/bin/bash

DPDK_VER=2.1.0

OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1
RTE_TARGET=x86_64-native-linuxapp-gcc
PATCHES="060679 060680 060681 060682 060683 060684 060685"
URL_OVS=https://github.com/openvswitch/ovs.git
URL_DPDK=http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.tar.gz

wget ${URL_DPDK}
tar -xzvf dpdk-${DPDK_VER}.tar.gz
cd dpdk-${DPDK_VER}
sed -i -e 's/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/' \
       -e 's/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/' \
       -e 's/CONFIG_RTE_PKTMBUF_HEADROOM=128/CONFIG_RTE_PKTMBUF_HEADROOM=256/' \
       config/common_linuxapp
cd /
tar -czvf dpdk-${DPDK_VER}.tar.gz dpdk-${DPDK_VER}
cd dpdk-${DPDK_VER}
make install T=${RTE_TARGET}
cd /

git clone ${URL_OVS} openvswitch-dpdk
cd openvswitch-dpdk
git checkout ${OVS_COMMIT} -b development
for patch in ${PATCHES}
do
        patch -p1 < /patches/${patch}.patch
done
export RTE_SDK=/dpdk-${DPDK_VER}
export DPDK_BUILD=${RTE_SDK}/${RTE_TARGET}
./boot.sh
./configure --with-dpdk=$DPDK_BUILD
sed -i "s?configure --with-linux?configure --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc --with-linux?" debian/dkms.conf.in;sed -i "s?configure --with-linux?configure --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc --with-linux?" debian/rules.modules;sed -i "s?configure --?configure -- --with-dpdk=/dpdk-2.1.0/x86_64-native-linuxapp-gcc?" debian/rules;make dist;tar -xzf openvswitch-2.4.90.tar.gz;
cd openvswitch-2.4.90;DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary
