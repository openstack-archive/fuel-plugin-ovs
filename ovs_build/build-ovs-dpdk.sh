#!/bin/bash

set -eux

OVS_COMMIT=9f4ecd654dbcb88b15a424445184591fc887537e
URL_OVS_ARCHIVE=https://github.com/openvswitch/ovs/archive
BUILD_DEB=${BUILD_DEB:-/deb}
BUILD_SRC="$(dirname `readlink -f $0`)"
BUILD_DEST=${BUILD_DEST:-/tmp/ovs-dpdk}

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get -y --force-yes install devscripts dpkg-dev wget

rm -rf ${BUILD_DEST}; mkdir -p ${BUILD_DEST}

cd ${BUILD_DEST}
wget -c http://fast.dpdk.org/rel/dpdk-16.07.tar.xz
xz -d dpdk-16.07.tar.xz; tar xvf dpdk-16.07.tar
cd dpdk-16.07
cp -r ${BUILD_SRC}/dpdk_16.07/debian .

# copy from debian/control
sudo apt-get install -y --force-yes debhelper \
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

cd ${BUILD_DEST}
sudo dpkg -i *.deb
apt-get download libxenstore3.0

sudo apt-get build-dep openvswitch -y --force-yes
# copy from debian/control
sudo apt-get install -y --force-yes autoconf \
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

wget -c ${URL_OVS_ARCHIVE}/${OVS_COMMIT}.tar.gz
tar xzf ${OVS_COMMIT}.tar.gz; mv ovs-${COMMIT} ovs
cp -r ovs ovs-dpdk

cd ovs-dpdk
cp -r ${BUILD_SRC}/openvswitch-dpdk_2.5.90/debian .
debian/rules build; fakeroot debian/rules binary

cd ${BUILD_DEST}/ovs
debian/rules build; fakeroot debian/rules binary

cp -r ${BUILD_DEST}/*.deb ${BUILD_DEB}
rm -rf ${BUILD_DEST}
