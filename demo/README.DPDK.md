Fuel OVS + DPDK Plugin Demo
===========================

Overview
--------

How to enable OVS + DPDK plugin in fuel 9.0

How to enalbe
-------------

1. ssh to the master node
2. Edit FEATURE_GROUPS field in /etc/nailgun/settings.yaml as:
 FEATURE_GROUPS:
   - "experimental"
3. Restart Nailgun
   systemctl restart nailgun.
   delete cluster nodes from fuel DB as fuel node --node-id 1,2 --delete-from-db --force.
   Boot cluster nodes.
4. set OVS plugin

5. Follow document[1] 

6. Enable Hugepages for Guest VM
   nova flavor-key m1.tiny set hw:mem_page_size=2048

Related Documents
---------------
[1] http://github.com/openstack/fuel-specs/blob/master/specs/9.0/support-dpdk.rst
