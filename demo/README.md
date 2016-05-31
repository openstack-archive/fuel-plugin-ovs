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

1. 01_setup_network.sh

The script is to setup socks5 proxy. You may change the script to support
NAT. The following network setting is updated before running the script:

a. HTTP_PROXY: proxy for package installation
b. DNS_SERVER: DNS for fuel VM
c. SOCK5_IP:  socks5 proxy for fuel VM
d. SOCK5_PORT: socks5 proxy for fuel VM

In fresh installation, 01_setup_network.sh can be run by:

curl --socks5 <socks5-proxy> https://raw.githubusercontent.com/openstack/fuel-plugin-ovs/master/demo/01_setup_network.sh | bash -s -- -h=<http-proxy>-d=<dns-server> -s=<socks5-ip> -p=<socks5-port>

2. 02_install_packages.sh

The script is to install all packages

3. 03_setup_vnc.sh

The script is to setup vnc. Default vnc password is 123456.

4. 04_setup_fuel.sh

The script is to create 1 master VM and 4 slave VMs. Fuel ISO is copied to this
directory before running the script.

5. 05_destroy_fuel.sh

The script is to destroy 1 master VM and 4 slave VMs.
