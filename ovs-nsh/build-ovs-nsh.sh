#!/bin/bash

OVS_COMMIT=121daded51b9798fe3722824b27a05c16806cbd1
PATCHES="060679 060680 060681 060682 060683 060684 060685"
URL_OVS=https://github.com/openvswitch/ovs.git

git clone ${URL_OVS} openvswitch
cd openvswitch
git checkout ${OVS_COMMIT} -b development
for patch in ${PATCHES}
do
        patch -p1 < /patches/${patch}.patch
done

./boot.sh;./configure;make dist;tar -xzf openvswitch-2.4.90.tar.gz
cd openvswitch-2.4.90;dpkg-checkbuilddeps;DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary
