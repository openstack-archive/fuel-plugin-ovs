#!/bin/bash

URL_OVS=https://github.com/openvswitch/ovs.git
OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1


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

cd dpdk-2.2.0; debian/rules build; fakeroot debian/rules binary
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

cd openvswitch-dpdk-2.4.0;
sed -i "s/include\/rte_config.h/include\/dpdk\/rte_config.h/" acinclude.m4
debian/rules build; fakeroot debian/rules binary
