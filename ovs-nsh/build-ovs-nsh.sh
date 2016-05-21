#!/bin/bash

OVS_COMMIT=7d433ae57ebb90cd68e8fa948a096f619ac4e2d8
URL_OVS=https://github.com/openvswitch/ovs.git

PATCHES="eeaf57e bf1e7ff 21bd423 17a6124 299fc5b"

cd $HOME

git clone ${URL_OVS} openvswitch

cd openvswitch
git checkout ${OVS_COMMIT} -b yyang13
for patch in ${PATCHES}
do
        patch -p1 < ${HOME}/patches/${patch}.patch
done

./boot.sh
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-linux=/lib/modules/$(uname -r)/build
make dist
OVSTBALL=$(echo openvswitch-*.tar.gz)
OVSART='openvswitch-2.5.90'


tar -xzf ${HOME}/openvswitch/$OVSTBALL
cd $OVSART
dpkg-checkbuilddeps
DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary

