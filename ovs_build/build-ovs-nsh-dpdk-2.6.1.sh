#!/bin/bash

set -eux

GIT_EMAIL="you@example.com"
GIT_USER="Your Name"
OVS_COMMIT=f4b0e64cffb4777ff03d48621c3eadcf1d8c19f3
URL_OVS=https://github.com/openvswitch/ovs.git
OVS_VER=${OVS_VER:-2.6.1}
OVS_NSH_PATCHES_COMMIT=03096b4f8f38cf337e9ae9f95bdded2b2bf7047a
URL_OVS_NSH_PATCHES=https://github.com/yyang13/ovs_nsh_patches
BUILD_HOME=$HOME/nsh
BUILD_DEST=${BUILD_DEST:-/deb}
BUILD_SRC="$(dirname `readlink -f $0`)"
DIR="$(dirname `readlink -f $0`)"

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get build-dep openvswitch -y
sudo apt-get -y install devscripts dpkg-dev git wget

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}
mkdir -p ${BUILD_DEST}

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

git config --global user.email ${GIT_EMAIL}
git config --global user.name ${GIT_USER}
git clone ${URL_OVS_NSH_PATCHES}
pushd ovs_nsh_patches
git checkout ${OVS_NSH_PATCHES_COMMIT}
popd
git clone ${URL_OVS}
pushd ovs
git checkout ${OVS_COMMIT}
git am ../ovs_nsh_patches/v2.6.1/*.patch
popd

cd ${BUILD_HOME}; tar czvf ovs.tar.gz ovs
rm -rf openvswitch-dpdk-${OVS_VER}*
cd openvswitch-dpdk-2.4.0; uupdate -v ${OVS_VER} ../ovs.tar.gz
cd ../openvswitch-dpdk-${OVS_VER}
cp acinclude.m4 ~/acinclude2.6.1.m4
#sed -i "s/include\/rte_config.h/include\/dpdk\/rte_config.h/" acinclude.m4
#sed -i 's/\[DPDK_INCLUDE=.*\]/\[DPDK_INCLUDE=$RTE_SDK\/include\/dpdk\]/'  acinclude.m4
autoreconf --install
rm -rf debian/patches/ .git;
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1.nsh) unstable; urgency=low
  * Support NSH
 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF
debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}/ovs
cat << EOF > debian/changelog
openvswitch (${OVS_VER}-1.nsh) unstable; urgency=low
  * Support NSH
 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF
debian/rules build; fakeroot debian/rules binary
cp ${BUILD_HOME}/*.deb ${BUILD_DEST}

