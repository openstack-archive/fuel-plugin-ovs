#!/bin/bash

OVS_COMMIT=cd4764fdd8ce0aa0063525dad0e67f20b3bcf6e9
URL_OVS=https://github.com/openvswitch/ovs.git
OVS_VER=${OVS_VER:-2.5.1}
BUILD_HOME=$HOME/dpdk
BUILD_DEST=${BUILD_DEST:-/deb}

sudo apt-get build-dep openvswitch -y
sudo apt-get -y install devscripts dpkg-dev git wget

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}

cd ${BUILD_HOME}
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.dsc
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0.orig.tar.gz
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/dpdk_2.2.0-0ubuntu8.debian.tar.xz
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

cd dpdk-2.2.0; rm -rf debian/patches/;
cat << EOF > debian/changelog
dpdk (2.2.0-1) unstable; urgency=low
   [ DPDK team]
   * New upstream version
EOF
debian/rules build; fakeroot debian/rules binary
cd ${BUILD_HOME}; sudo dpkg -i *.deb

cd ${BUILD_HOME}
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0.orig.tar.gz
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.dsc
wget -c https://launchpad.net/ubuntu/+archive/primary/+files/openvswitch-dpdk_2.4.0-0ubuntu1.debian.tar.xz
dpkg-source -x openvswitch-dpdk_2.4.0-0ubuntu1.dsc

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
               python-zopeinterface \
               python-six

git clone https://github.com/openvswitch/ovs.git
cd ovs; git checkout ${OVS_COMMIT}
cd ${BUILD_HOME}; tar czvf ovs.tar.gz ovs
rm -rf openvswitch-dpdk-${OVS_VER}*
cd openvswitch-dpdk-2.4.0; uupdate -v ${OVS_VER} ../ovs.tar.gz
cd ../openvswitch-dpdk-${OVS_VER}
sed -i "s/include\/rte_config.h/include\/dpdk\/rte_config.h/" acinclude.m4
sed -i 's/DPDK_INCLUDE=.*/DPDK_INCLUDE=$RTE_SDK\/include\/dpdk/'  acinclude.m4
autoreconf --install
rm -rf debian/patches/ .git;
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1) unstable; urgency=low
   [ Open vSwitch team ]
   * Open vSwitch Upstream
EOF
debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}/ovs
debian/rules build; fakeroot debian/rules binary

cp ${BUILD_HOME}/*.deb ${BUILD_DEST}
