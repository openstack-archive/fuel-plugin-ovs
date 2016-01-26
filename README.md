Openvswitch Plugin for Fuel
================================

Openvswitch plugin
-----------------------

Overview
--------

New fuel plugin fuel-plugin-ovs is developed to deploy OVS with NSH + DPDK in Fuel@OPNFV, which is requested by ODL project

Requirements
------------

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Mirantis OpenStack compatibility | 8.0             |

Recommendations
---------------

None.

Limitations
-----------

None.

Installation Guide
==================

Openvswitch plugin installation
----------------------------------------

1. Clone the fuel-plugin-ovs repo from stackforge:

        git clone https://github.com/openstack/fuel-plugin-ovs

2. Install the Fuel Plugin Builder:

        pip install fuel-plugin-builder

3. Build Openvswitch Fuel plugin:

        fpb --build fuel-plugin-ovs/

4. The *fuel-plugin-ovs-[x.x.x].rpm* plugin package will be created in the plugin folder.

5. Move this file to the Fuel Master node with secure copy (scp):

        scp fuel-plugin-ovs-[x.x.x].rpm root@<the_Fuel_Master_node_IP address>:/tmp

6. While logged in Fuel Master install the Openvswitch plugin:

        fuel plugins --install fuel-plugin-ovs-[x.x.x].rpm

7. Check if the plugin was installed successfully:

        fuel plugins

        id | name            | version | package_version
        ---|-----------------|---------|----------------
        1  | fuel-plugin-ovs | 0.5.2   | 3.0.0

8. Plugin is ready to use and can be enabled on the Settings tab of the Fuel web UI.


User Guide
==========

Openvswitch plugin configuration
---------------------------------------------

1. Create a new environment with the Fuel UI wizard.
2. Click on the Settings tab of the Fuel web UI.
3. Scroll down the page, select the plugin checkbox.


Build options
-------------

It is possible to modify process of building plugin by setting environment variables. Look into [pre_build_hook file](pre_build_hook) for more details.

Dependencies
------------

If you plan to use plugin in environment without internet access or/and CentOS environment modify build command:

     INCLUDE_DEPENDENCIES=true fpb --build fuel-plugin-ovs/

Pre build script will try download required dependencies so it become part of the compiled plugin.

Note: List of packages for [ubuntu](ovs_package/ubuntu/dependencies.txt) and [centos](ovs_package/centos/dependencies.txt) may need to be modified if packages in centos or ubuntu repositories will change.

Testing
-------

None.

Known issues
------------

None.


Development
===========

The *OpenStack Development Mailing List* is the preferred way to communicate,
emails should be sent to `openstack-dev@lists.openstack.org` with the subject
prefixed by `[fuel][plugins][ovs]`.

Reporting Bugs
--------------

Bugs should be filled on the [Launchpad fuel-plugins project](
https://bugs.launchpad.net/fuel-plugins) (not GitHub) with the tag `ovs`.


Contributing
------------

If you would like to contribute to the development of this Fuel plugin you must
follow the [OpenStack development workflow](
http://docs.openstack.org/infra/manual/developers.html#development-workflow).

Patch reviews take place on the [OpenStack gerrit](
https://review.openstack.org/#/q/status:open+project:stackforge/fuel-plugin-ovs,n,z)
system.

Contributors
------------

* ling.y.yu@intel.com,ruijing.guo@intel.com

