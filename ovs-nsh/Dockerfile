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

ADD ./download-ovs-nsh-dpdk.sh /root/download-ovs-nsh-dpdk.sh
RUN chmod +x /root/download-ovs-nsh-dpdk.sh
RUN /root/download-ovs-nsh-dpdk.sh

ADD ./build-ovs-nsh.sh /root/build-ovs-nsh.sh
RUN chmod +x /root/build-ovs-nsh.sh
RUN /root/build-ovs-nsh.sh

ADD ./build-ovs-nsh-dpdk.sh /root/build-ovs-nsh-dpdk.sh
RUN chmod +x /root/build-ovs-nsh-dpdk.sh
RUN /root/build-ovs-nsh-dpdk.sh
