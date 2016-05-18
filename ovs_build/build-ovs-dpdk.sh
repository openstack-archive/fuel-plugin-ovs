#!/bin/bash

OVS_COMMIT=cd4764fdd8ce0aa0063525dad0e67f20b3bcf6e9

BUILD_HOME=`pwd`
sudo apt-get update -y
sudo apt-get build-dep openvswitch -y
sudo apt-get -y install devscripts dpkg-dev git wget

cd ${BUILD_HOME}
wget https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.dsc
wget https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0.orig.tar.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.debian.tar.xz
dpkg-source -x dpdk_2.2.0-0ubuntu8.dsc

# copy from debian/control
sudo apt-get install -y debhelper \
               dh-python \
               dh-systemd \
               doxygen  \
               graphviz  \
               inkscape  \
               libcap-dev  \
               libpcap-dev  \
               libxen-dev  \
               libxenstore3.0  \
               python  \
               python-sphinx  \
               texlive-fonts-recommended  \
               texlive-latex-extra

cd dpdk-2.2.0; rm -rf debian/patches/; debian/rules build; fakeroot debian/rules binary
cd ${BUILD_HOME}; sudo dpkg -i *.deb

cd ${BUILD_HOME}
wget https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0.orig.tar.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.dsc
wget https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.debian.tar.xz
dpkg-source -x  openvswitch-dpdk_2.4.0-0ubuntu1.dsc


# copy from debian/control
sudo apt-get intall -y autoconf \
               automake \
               bzip2 \
               debhelper \
               dh-autoreconf \
               dh-systemd \
               graphviz \
               libdpdk-dev \
               libfuse-dev \
               libssl-dev \
               libtool \
               openssl \
               procps \
               python-all \
               python-qt4 \
               python-twisted-conch \
               python-zopeinterface

git clone https://github.com/openvswitch/ovs.git
cd ovs; git checkout ${OVS_COMMIT}
cd ${BUILD_HOME}; tar czvf ovs.tar.gz ovs
rm -rf openvswitch-dpdk-2.5.0*
cd openvswitch-dpdk-2.4.0; uupdate -v 2.5.0 ../ovs.tar.gz
cd ../openvswitch-dpdk-2.5.0
sed -i "s/include\/rte_config.h/include\/dpdk\/rte_config.h/" acinclude.m4
sed -i 's/DPDK_INCLUDE=.*/DPDK_INCLUDE=$RTE_SDK\/include\/dpdk/'  acinclude.m4
autoreconf --install
rm -rf debian/patches/ .git;
debian/rules build; fakeroot debian/rules binary
