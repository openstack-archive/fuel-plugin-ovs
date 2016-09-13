#!/bin/bash
set -eux

. /root/openrc

#foreach nova flavor name set it to have it's memory backed with large pages
#so that it will run with DPDK-enabled OVS.
for i in `nova flavor-list | tail -n +4 | head --lines=-1 | awk {'print $4'}`; do
    nova flavor-key $i set "hw:mem_page_size=large"
done
