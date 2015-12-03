$fuel_settings = parseyaml(file('/etc/compute.yaml'))
if $operatingsystem == 'Ubuntu' {
        if $fuel_settings['fuel-plugin-ovs']['use_dpdk'] {
                exec { "wget dpdk":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk-install/dpdk-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
                exec { "install dpdk":
                        command => "bash /etc/fuel/plugins/fuel-plugin-ovs-0.5/dpdk-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
                package { 'openvswitch-datapath-dkms':
                        ensure => "2.4.91-1",
                }
                package { 'openvswitch-common':
                        ensure => "2.4.91-1",
                }
                package { 'openvswitch-switch':
                        ensure => "2.4.91-1",
                        require => Package['openvswitch-common','openvswitch-datapath-dkms'],
                }
        } else {
                exec { "install openvswitch-datapath-dkms package":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/openvswitch-datapath-dkms_2.4.90-1_all.deb;sudo dpkg -i openvswitch-datapath-dkms_2.4.90-1_all.deb",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
                exec { "install openvswitch-common package":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/openvswitch-common_2.4.90-1_amd64.deb;sudo dpkg -i openvswitch-common_2.4.90-1_amd64.deb",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
                exec { "install openvswitch-switch package":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/openvswitch-switch_2.4.90-1_amd64.deb;sudo dpkg -i openvswitch-switch_2.4.90-1_amd64.deb",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
        }
        if $fuel_settings['fuel-plugin-ovs']['use_dppd'] {
                exec { "wget dppd":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dppd-install/dppd-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
                exec { "install dppd":
                        command => "bash /etc/fuel/plugins/fuel-plugin-ovs-0.5/dppd-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
        }
} elsif $operatingsystem == 'CentOS' {
}