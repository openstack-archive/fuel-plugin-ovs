#!/bin/bash

set -eux

OVS_COMMIT=f4b0e64cffb4777ff03d48621c3eadcf1d8c19f3
OVS_VER=${OVS_VER:-2.6.1}
BUILD_DEST=${BUILD_DEST:-/deb}
BUILD_SRC="$(dirname `readlink -f $0`)"
BUILD_HOME=${BUILD_HOME:-/tmp/ovs-dpdk}

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get -y --force-yes install devscripts dpkg-dev git wget dkms

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}/deb

cd ${BUILD_HOME}
wget -c http://fast.dpdk.org/rel/dpdk-16.07.tar.xz
xz -d dpdk-16.07.tar.xz; tar xvf dpdk-16.07.tar
cd dpdk-16.07
cp -r ${BUILD_SRC}/dpdk_16.07.fuel/debian .
cat << EOF > debian/changelog
dpdk (16.07-0ubuntu5~u1604+fuel10) xenial; urgency=low

  * Rebuild debian package
  * update librte-eal2.symbols

 -- Ruijing Guo <ruijing.guo@intel.com>  $(date --rfc-2822)
EOF

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

cd ${BUILD_HOME}
sudo apt-get install -y --force-yes hwdata
sudo dpkg -i *.deb
mv *.deb ${BUILD_DEST}

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

git clone https://github.com/openvswitch/ovs.git
cd ovs; git checkout ${OVS_COMMIT}; rm -rf .git
PATCHES=$(cd ${BUILD_SRC}/ovs_nsh_patches/v2.6.1/; echo *patch)
for patch in ${PATCHES}
do
    patch -p1 < ${BUILD_SRC}/ovs_nsh_patches/v2.6.1/${patch}
done
cd ${BUILD_HOME}; cp -r ovs ovs-dpdk

cd ovs-dpdk
cp -r ${BUILD_SRC}/openvswitch_2.6-dpdk_16.07/debian .
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1.nsh) unstable; urgency=low
  [ Open vSwitch team ]
  * support NSH & DPDK 16.07

 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF

debian/rules build; fakeroot debian/rules binary

cd ${BUILD_HOME}/ovs
cat << EOF > debian/changelog
openvswitch (${OVS_VER}-1.nsh) unstable; urgency=low
  [ Open vSwitch team ]
  * support NSH

 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF
debian/rules build; fakeroot debian/rules binary

cp -r ${BUILD_HOME}/*.deb ${BUILD_HOME}/deb
cd ${BUILD_HOME}/deb
tar czvf ${BUILD_DEST}/ovs-nsh-dpdk.tar.gz .;
