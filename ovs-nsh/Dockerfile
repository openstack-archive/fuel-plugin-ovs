#!/bin/bash

FROM ubuntu:14.04.3
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties \
    make python-setuptools python-all dpkg-dev debhelper \
    fuseiso git genisoimage bind9-host wget curl lintian tmux lxc iptables \
    ca-certificates sudo apt-utils lsb-release libtool autoconf automake build-essential fakeroot libssl-dev graphviz dh-autoreconf python-qt4 python-twisted-conch python-zopeinterface linux-headers-`uname -r`

RUN echo "ALL ALL=NOPASSWD: ALL" > /etc/sudoers.d/open-sudo
RUN chmod 0440 /etc/sudoers.d/open-sudo

ADD ./patches /patches

ADD ./build-ovs-nsh.sh /build-ovs-nsh.sh
RUN chmod +x /build-ovs-nsh.sh
RUN /build-ovs-nsh.sh

ADD ./build-ovs-nsh-dpdk.sh /build-ovs-nsh-dpdk.sh
RUN chmod +x /build-ovs-nsh-dpdk.sh
RUN /build-ovs-nsh-dpdk.sh
