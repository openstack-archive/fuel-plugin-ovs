#!/bin/bash

FROM ubuntu:14.04.3

RUN apt-get update -y
RUN rm -rf /lib/modules
RUN apt-get install -y linux-headers-3.13.0-86-generic
RUN ln -s /lib/modules/3.13.0-86-generic /lib/modules/`uname -r`

ADD ./  /ovs_build
