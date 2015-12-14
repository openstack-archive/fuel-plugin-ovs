$fuel_settings = parseyaml(file('/etc/controller.yaml'))
if $operatingsystem == 'Ubuntu' {
        if $fuel_settings['fuel-plugin-ovs']['use_dpdk'] {
                $NICS = $fuel_settings['fuel-plugin-ovs']['dpdk-bind-nic']
                exec { "install dpdk":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk-install.sh; bash ./dpdk-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                } ->
                exec {'dpdk-init':
                command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.init -O /etc/init.d/dpdk;chmod +x /etc/init.d/dpdk",
                path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                } ->
                exec {'dpdk-conf':
                command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/dpdk.conf -O /etc/default/dpdk.conf",
                path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                } ->
                exec {'adapt_conf_file':
                command => "sed 's/DPDK_NIC_MAPPINGS=.*/DPDK_NIC_MAPPINGS=${NICS}/' -i /etc/default/dpdk.conf",
                path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                } ->
                exec {'dpdk start':
                command => "bash /etc/init.d/dpdk start",
                path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                } ->
                exec { "install ovs with dpdk":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dpdk/ovs-dpdk-install.sh; bash ./ovs-dpdk-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
        } else {
                exec { "install ovs":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/ovs/ovs-install.sh; bash ./ovs-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
        }
        if $fuel_settings['fuel-plugin-ovs']['use_dppd'] {
                exec { "install dppd":
                        command => "wget http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.5/repositories/ubuntu/dppd/dppd-install.sh; bash ./dppd-install.sh",
                        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
                }
        }
} elsif $operatingsystem == 'CentOS' {
}
