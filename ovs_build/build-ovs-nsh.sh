#!/bin/bash

BUILD_HOME=`pwd`/tmp

OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1
PATCHES="060679 060680 060681 060682 060683 060684 060685"
URL_OVS=https://github.com/openvswitch/ovs.git

mkdir -p ${BUILD_HOME}
cd ${BUILD_HOME}
git clone ${URL_OVS} openvswitch
cd openvswitch
git checkout ${OVS_COMMIT} -b development
for patch in ${PATCHES}
do
    patch -p1 < /ovs_build/patches/${patch}.patch
done

export DEB_BUILD_OPTIONS='parallel=8 nocheck'
sed -i "s/2.4.90/2.4.90.nsh/g" debian/changelog
debian/rules build
fakeroot debian/rules binary
cp ${BUILD_HOME}/*.deb /deb
