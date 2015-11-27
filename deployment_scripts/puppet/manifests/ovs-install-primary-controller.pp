$fuel_settings = parseyaml(file('/etc/primary-controller.yaml'))
if $operatingsystem == 'Ubuntu' {
        if $fuel_settings['fuel-plugin-ovs']['use_dpdk'] {
		exec { "wget dpdk package":
		        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk-install.tar.gz",
		        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
		}
		exec { "unzip dpdk package":
		        command => "tar -xvzf /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install.tar.gz",
		        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
		}
		exec { "install dpdk package":
		        command => "/etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install/dpdk-install.sh",
		        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
		}
                package { 'openvswitch-datapath-dkms':
                        ensure => "2.4.90-1",
                }
                package { 'openvswitch-common':
                        ensure => "2.4.90-1",
                }
                package { 'openvswitch-switch':
                        ensure => "2.4.90-1",
                        require => Package['openvswitch-common','openvswitch-datapath-dkms'],
                }
	} else {
                package { 'openvswitch-datapath-dkms':
                        ensure => "2.4.90-1",
                }
                package { 'openvswitch-common':
                        ensure => "2.4.90-1",
                }
                package { 'openvswitch-switch':
                        ensure => "2.4.90-1",
                        require => Package['openvswitch-common','openvswitch-datapath-dkms'],
                }
	}
} elsif $operatingsystem == 'CentOS' {
}
