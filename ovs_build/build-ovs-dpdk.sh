#!/bin/bash

set -eux

OVS_COMMIT=7d8eadce4df70f563a0c0123c612f6117c8ff864
URL_OVS=https://github.com/openvswitch/ovs.git
OVS_VER=${OVS_VER:-2.5.90}
BUILD_HOME=$HOME/dpdk
BUILD_DEST=${BUILD_DEST:-/deb}

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get build-dep openvswitch -y
sudo apt-get -y install devscripts dpkg-dev git wget

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}
cp rules ${BUILD_HOME}

cd ${BUILD_HOME}
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.dsc
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0.orig.tar.gz
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.debian.tar.xz
dpkg-source -x dpdk_2.2.0-0ubuntu8.dsc
wget -c http://fast.dpdk.org/rel/dpdk-16.04.tar.xz

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

cd dpdk-2.2.0; rm -rf debian/patches/; uupdate -v 16.04 ../dpdk-16.04.tar.xz
cd ${BUILD_HOME}/dpdk-16.04
cat << EOF > debian/changelog
dpdk (16.04-1) unstable; urgency=low
  * DPDK 16.04
 -- DPDK team <dev@dpdk.org>
EOF
mv debian/rules debian/rules.orig
cp ${BUILD_HOME}/rules debian/rules
debian/rules build; fakeroot debian/rules binary
cd ${BUILD_HOME}; sudo dpkg -i *.deb
apt-get download libxenstore3.0

cd ${BUILD_HOME}
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0.orig.tar.gz
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.dsc
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.debian.tar.xz
dpkg-source -x openvswitch-dpdk_2.4.0-0ubuntu1.dsc

# copy from debian/control
sudo apt-get install -y autoconf \
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
               python-zopeinterface \
               python-six

git clone https://github.com/openvswitch/ovs.git
cd ovs; git checkout ${OVS_COMMIT}
cd ${BUILD_HOME}; tar czvf ovs.tar.gz ovs
rm -rf openvswitch-dpdk-${OVS_VER}*
cd openvswitch-dpdk-2.4.0; uupdate -v ${OVS_VER} ../ovs.tar.gz
cd ../openvswitch-dpdk-${OVS_VER}
#sed -i 's~DPDK_LIB_DIR=.*~DPDK_LIB_DIR="$with_dpdk/x86_64-linux-gnu/lib"~'  acinclude.m4
autoreconf --install
rm -rf debian/patches/ .git;
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1) unstable; urgency=low
  * New upstream version
 -- Open vSwitch team <dev@openvswitch.org>
EOF
debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}/ovs
debian/rules build; fakeroot debian/rules binary

cp ${BUILD_HOME}/*.deb ${BUILD_DEST}
