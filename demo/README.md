Fuel OVS Plugin Demo Script
===========================

Overview
--------

This directory includes scripts to setup fuel ovs plugin demo.

The scripts are ONLY tested in new installation of Ubuntu 14.04.03 Desktop
64bit in server:
a. 16G Memory
b. 1T Disk
c. virtualization support

Extra configuration or Extra packages such as virtualbox may break
functionality. All packages or network configuration are provided by the
the following scripts.

Scripts
-------

0. 00_bootstrap.sh
   a. copy from https://raw.githubusercontent.com/openstack/fuel-plugin-ovs/master/demo/00_bootstrap.sh
   b. change HTTP_PROXY
   c. run the script

1. 01_setup_network.sh

The script is to setup socks5 proxy. You may change the script to support
NAT. The following network setting is updated before running the script:

a. SOCK5_IP:  socks5 proxy for fuel VM
b. SOCK5_PORT: socks5 proxy for fuel VM
b. RED_TCPORT: redsocks tcp port

2. 02_install_packages.sh

The script is to install all packages

3. 03_setup_vnc.sh

The script is to setup vnc. Default vnc password is 123456.

4. 04_setup_fuel.sh

The script is to create 1 master VM and 4 slave VMs:

a. change DNS_SERVER
b. download ISO in fuel-plugin-ovs/demo
   Examle1: wget http://seed-us1.fuel-infra.org/fuelweb-community-release/fuel-community-9.0.iso.
   Examle2: wget http://artifacts.opnfv.org/fuel/opnfv-2016-08-03_23-58-37.iso
c. run the script

5. 94_destroy_fuel.sh

The script is to destroy 1 master VM and 4 slave VMs.
