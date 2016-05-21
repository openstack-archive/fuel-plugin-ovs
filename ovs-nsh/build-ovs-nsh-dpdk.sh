#!/bin/bash

git config --global user.email "build@opnfv.org"
git config --global user.name "build"

DPDK_VER=2.2.0
URL_DPDK=http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VER}.tar.gz
export RTE_SDK=/root/dpdk-${DPDK_VER}
export RTE_TARGET=x86_64-native-linuxapp-gcc
export DPDK_BUILD=${RTE_SDK}/${RTE_TARGET}


OVS_COMMIT=7d433ae57ebb90cd68e8fa948a096f619ac4e2d8
URL_OVS=https://github.com/openvswitch/ovs.git

cd $HOME
wget ${URL_DPDK}
tar -xzvf dpdk-${DPDK_VER}.tar.gz
cd dpdk-${DPDK_VER}
sed -i -e 's/CONFIG_RTE_LIBRTE_VHOST=n/CONFIG_RTE_LIBRTE_VHOST=y/' \
       -e 's/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/' \
       -e 's/CONFIG_RTE_PKTMBUF_HEADROOM=128/CONFIG_RTE_PKTMBUF_HEADROOM=256/' \
       config/common_linuxapp
cd $HOME
tar -czvf dpdk-${DPDK_VER}.tar.gz dpdk-${DPDK_VER}
cd dpdk-${DPDK_VER}
make install T=${RTE_TARGET}
find . | grep "\.o$" | xargs rm -rf
cd $HOME
tar czvf dpdk-${DPDK_VER}.bin.tar.gz dpdk-${DPDK_VER}

rm -rf patches
git clone https://github.com/yyang13/ovs_nsh_patches.git patches
pushd patches
PATCHES=$(echo *patch)
popd


git clone ${URL_OVS} openvswitch-dpdk
cd openvswitch-dpdk
git checkout ${OVS_COMMIT} -b yyang13
for patch in ${PATCHES}
do
        git am ${HOME}/patches/${patch}
done

./boot.sh
./configure --with-dpdk=$DPDK_BUILD
sed -i "s?set ovs-vswitchd unix?set ovs-vswitchd --dpdk -c 0x1 -n 4 -- unix?" utilities/ovs-ctl.in;sed -i "s?configure --with-linux?configure --with-dpdk=$DPDK_BUILD --with-linux?" debian/dkms.conf.in;sed -i "s?configure --with-linux?configure --with-dpdk=$DPDK_BUILD --with-linux?" debian/rules.modules;sed -i "s?configure --?configure -- --with-dpdk=$DPDK_BUILD?" debian/rules;make dist;tar -xzf openvswitch-2.5.90.tar.gz;
cd openvswitch-2.5.90;DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary


cd $HOME
wget https://01.org/sites/default/files/downloads/intel-data-plane-performance-demonstrators/dppd-prox-v021.zip
unzip dppd-prox-v021.zip

cd dppd-PROX-v021
export DPPD_DIR=$(pwd); make
find . | grep "\.o$" | xargs rm -rf
cd $HOME
tar -czvf dppd-prox-v021.bin.tar.gz dppd-PROX-v021
