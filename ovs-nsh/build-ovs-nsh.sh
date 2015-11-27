#!/bin/bash

cd /openvswitch;./boot.sh;./configure;make dist;tar -xzf openvswitch-2.4.90.tar.gz
cd /openvswitch/openvswitch-2.4.90;dpkg-checkbuilddeps;DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary
