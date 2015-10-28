$fuel_settings = parseyaml(file('/etc/compute.yaml'))
$ovs_version = "2.4.90-1"
if $operatingsystem == 'Ubuntu' {
        package { 'openvswitch-datapath-dkms':
                ensure => "${ovs_version}",
        }
        package { 'openvswitch-common':
                ensure => "${ovs_version}",
        }
        package { 'openvswitch-switch':
                ensure => "${ovs_version}",
                require => Package['openvswitch-common','openvswitch-datapath-dkms'],
        }
} elsif $operatingsystem == 'CentOS' {
        if $fuel_settings['fuel-plugin-ovs']['use_dpdk'] {
                package { 'openvswitch':
                        ensure => "2.4.90-1.el6",
                }
                package { 'kmod-openvswitch':
                        ensure => "2.4.90-2.el6",
                }
                package { 'dpdk':
                        ensure => "2.1.0-6.el6",
                }
                package { 'dpdk-tools':
                        ensure => "2.1.0-6.el6",
                }
                package { 'dpdk-devel':
                        ensure => "2.1.0-6.el6",
                }

        } else {
                package { 'openvswitch':
                        ensure =>"2.4.90-1",
                }
                package { 'kmod-openvswitch':
                        ensure => "2.4.90-1.el6",
                }
        }
}
