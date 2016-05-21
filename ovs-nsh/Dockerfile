#!/bin/bash

FROM ubuntu:14.04.3

ENV HOME /root
RUN rm -rf /lib/modules
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties\
    make python-setuptools apt-utils autoconf automake bind9-host\
    build-essential bzip2 ca-certificates curl debhelper dh-autoreconf\
    dpkg-dev fakeroot fuseiso genisoimage git graphviz iptables\
    libssl-dev libtool lintian python-flake8 dh-python\
    lsb-release lxc openssl procps python-all python-qt4 python-setuptools\
    python-six python-twisted-conch python-zopeinterface python3-six\
    sudo tmux wget linux-headers-3.13.0-85-generic

RUN ln -s /lib/modules/3.13.0-85-generic /lib/modules/$(uname -r)

RUN apt-get install -y pkg-config unzip liblua5.2-dev libpcap0.8-dev libcap-ng-dev libedit-dev libncurses5-dev libncursesw5-dev

RUN echo "ALL ALL=NOPASSWD: ALL" > /etc/sudoers.d/open-sudo
RUN chmod 0440 /etc/sudoers.d/open-sudo

ADD ./build-ovs-nsh.sh /root/build-ovs-nsh.sh
RUN chmod +x /root/build-ovs-nsh.sh
RUN /root/build-ovs-nsh.sh

ADD ./build-ovs-nsh-dpdk.sh /root/build-ovs-nsh-dpdk.sh
RUN chmod +x /root/build-ovs-nsh-dpdk.sh
RUN /root/build-ovs-nsh-dpdk.sh
