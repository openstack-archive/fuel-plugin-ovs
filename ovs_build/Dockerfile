#!/bin/bash

FROM ubuntu:14.04.3

RUN apt-get update -y

RUN rm -rf /lib/modules
RUN apt-get install -y linux-headers-3.13.0-76-generic
RUN ln -s /lib/modules/3.13.0-76-generic /lib/modules/`uname -r`

RUN apt-get build-dep openvswitch -y
RUN apt-get -y install devscripts dpkg-dev git wget

ADD ./  /ovs_build
