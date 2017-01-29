#!/bin/bash

set -eux

OVS_COMMIT=f4b0e64cffb4777ff03d48621c3eadcf1d8c19f3
OVS_VER=${OVS_VER:-2.6.1}
BUILD_DEST=${BUILD_DEST:-/deb}
BUILD_SRC="$(dirname `readlink -f $0`)"
BUILD_HOME=${BUILD_HOME:-/tmp/ovs-dpdk}

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

function debian_build() {
  if [ -f "${BUILD_SRC}/build_debian_source" ]; then
    dpkg-source -b .
    cp -f ../*.{dsc,xz} ${BUILD_HOME}/deb
  fi
  debian/rules build; fakeroot debian/rules binary
}

function debian_src_prepare_ovs() {
  if [ -f "${BUILD_SRC}/build_debian_source" ]; then
    suffix="${OVS_VER}.orig.tar.xz"
    tar cJf ../openvswitch_${suffix} --exclude='./debian' .
    cd ..; ln -sf openvswitch_${suffix} openvswitch-dpdk_${suffix}; cd -
  fi
}

sudo apt-get -y --force-yes install devscripts dpkg-dev git wget dkms

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}/deb

cd ${BUILD_HOME}
wget -c http://fast.dpdk.org/rel/dpdk-16.07.tar.xz -O dpdk_16.07.orig.tar.xz
tar xJvf dpdk_16.07.orig.tar.xz
cd dpdk-16.07
cp -r ${BUILD_SRC}/dpdk_16.07.fuel/debian .
cat << EOF > debian/changelog
dpdk (16.07-0ubuntu5~u1604+fuel10) xenial; urgency=low

  * Rebuild debian package
  * update librte-eal2.symbols

 -- Ruijing Guo <ruijing.guo@intel.com> $(date --rfc-2822)
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
debian_build

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
cd ovs; git checkout ${OVS_COMMIT}; rm -rf .git; debian_src_prepare_ovs
mkdir -p debian/patches; mkdir -p .pc
PATCHES=$(cd ${BUILD_SRC}/ovs_nsh_patches/v2.6.1/; echo *patch)
for patch in ${PATCHES}
do
    echo "${patch}" >> debian/patches/series
    cp ${BUILD_SRC}/ovs_nsh_patches/v2.6.1/${patch} debian/patches/
    patch -p1 < debian/patches/${patch}
done
cp debian/patches/series .pc/applied-patches
cd ${BUILD_HOME}; cp -r ovs ovs-dpdk

cd ovs-dpdk
cp -r ${BUILD_SRC}/openvswitch_2.6-dpdk_16.07/debian .
cat << EOF > debian/changelog
openvswitch-dpdk (${OVS_VER}-1.nsh) unstable; urgency=low
  [ Open vSwitch team ]
  * support NSH & DPDK 16.07

 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF

debian_build

cd ${BUILD_HOME}/ovs
cat << EOF > debian/changelog
openvswitch (${OVS_VER}-1.nsh) unstable; urgency=low
  [ Open vSwitch team ]
  * support NSH

 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF
debian_build

cp -r ${BUILD_HOME}/*.deb ${BUILD_HOME}/deb
cd ${BUILD_HOME}/deb
tar czvf ${BUILD_DEST}/ovs-nsh-dpdk.tar.gz .;
