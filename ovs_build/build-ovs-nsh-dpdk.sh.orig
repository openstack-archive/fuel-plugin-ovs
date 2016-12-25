#!/bin/bash

set -eux

OVS_COMMIT=f4b0e64cffb4777ff03d48621c3eadcf1d8c19f3
URL_OVS=https://github.com/openvswitch/ovs.git
OVS_VER=${OVS_VER:-2.6.1}
BUILD_HOME=$HOME/nsh
BUILD_DEST=${BUILD_DEST:-/deb}
DIR="$(dirname `readlink -f $0`)"

export DEB_BUILD_OPTIONS='parallel=8 nocheck'

sudo apt-get -y install devscripts dpkg-dev git wget

rm -rf ${BUILD_HOME}; mkdir -p ${BUILD_HOME}

cd ${BUILD_HOME}

# copy from debian/control
sudo apt-get install -y \
               graphviz \
               autoconf \
               automake \
               bzip2 \
               debhelper \
               dh-autoreconf \
               libssl-dev \
               libtool \
               openssl \
               procps \
               python-all \
               python-twisted-conch \
               python-zopeinterface \
               python-six

git clone https://github.com/openvswitch/ovs.git
cd ovs; git checkout ${OVS_COMMIT}
PATCHES=$(cd ${DIR}/ovs_nsh_patches/v2.6.1/; echo *patch)
for patch in ${PATCHES}
do
    patch -p1 < ${DIR}/ovs_nsh_patches/v2.6.1/${patch}
done

# build ovs
cd ${BUILD_HOME}/ovs
cat << EOF > debian/changelog
openvswitch (${OVS_VER}-1.nsh) unstable; urgency=low
  * Support NSH
 -- Open vSwitch team <dev@openvswitch.org>  $(date --rfc-2822)
EOF
debian/rules build; fakeroot debian/rules binary
cp ${BUILD_HOME}/*.deb ${BUILD_DEST}
