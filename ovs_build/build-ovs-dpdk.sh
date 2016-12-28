#!/bin/bash

set -eux

OVS_COMMIT=92043ab8ffd449dfd50c3e716d6db06d04af70d7
OVS_VER=${OVS_VER:-2.6.90}
BUILD_DEST=${BUILD_DEST:-/deb}
BUILD_SRC="$(dirname `readlink -f $0`)"
BUILD_HOME=${BUILD_HOME:-/tmp/ovs-dpdk}

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get -y install devscripts dpkg-dev git wget

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}

cd ${BUILD_HOME}
wget -c http://fast.dpdk.org/rel/dpdk-16.07.tar.xz
xz -d dpdk-16.07.tar.xz; tar xvf dpdk-16.07.tar
cd dpdk-16.07
cp -r ${BUILD_SRC}/dpdk_16.07/debian .

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
debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}
sudo dpkg -i *.deb
apt-get download libxenstore3.0

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
cd ovs; git checkout ${OVS_COMMIT}; rm -rf .git
cd ${BUILD_HOME}; cp -r ovs ovs-dpdk

cd ovs-dpdk
cp -r ${BUILD_SRC}/openvswitch_2.6-dpdk_16.07/debian .
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1) unstable; urgency=low
  [ Open vSwitch team ]
  * support OVS with DPDK 16.07

 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF

debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}/ovs
debian/rules build; fakeroot debian/rules binary

cp -r ${BUILD_HOME}/*.deb ${BUILD_DEST}
rm -rf ${BUILD_HOME}
