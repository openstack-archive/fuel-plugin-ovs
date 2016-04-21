#!/bin/bash

DPDK_VER=2.1.0

export RTE_TARGET=x86_64-native-linuxapp-gcc
export RTE_SDK=/dpdk-${DPDK_VER}
export DPDK_BUILD=${RTE_SDK}/${RTE_TARGET}

OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1
URL_OVS=https://github.com/openvswitch/ovs.git
URL_DPDK=http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.tar.gz

cd /
wget ${URL_DPDK}
tar -xzvf dpdk-${DPDK_VER}.tar.gz
cd dpdk-${DPDK_VER}
sed -i -e 's/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/' \
       -e 's/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/' \
       -e 's/CONFIG_RTE_PKTMBUF_HEADROOM=128/CONFIG_RTE_PKTMBUF_HEADROOM=256/' \
       config/common_linuxapp
make install T=${RTE_TARGET}

cd /
git clone ${URL_OVS} openvswitch
cd openvswitch
git checkout ${OVS_COMMIT} -b development

export DEB_BUILD_OPTIONS='parallel=8 nocheck'
sed -i "s/2.4.90/2.4.90.dpdk/g" debian/changelog
sed -i "s/DATAPATH_CONFIGURE_OPTS.*=.*//" debian/rules
sed -i "2iDATAPATH_CONFIGURE_OPTS='--with-dpdk=$DPDK_BUILD'" debian/rules
sed -i "s/DATAPATH_CONFIGURE_OPTS.*=.*//" debian/rules.modules
sed -i "2iDATAPATH_CONFIGURE_OPTS='--with-dpdk=$DPDK_BUILD'" debian/rules.modules
debian/rules build
fakeroot debian/rules binary

cp /*.deb /build
