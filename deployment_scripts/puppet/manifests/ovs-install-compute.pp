$fuel_settings = parseyaml(file('/etc/astute.yaml'))
if $operatingsystem == 'Ubuntu' {
    if $fuel_settings['fuel-plugin-ovs']['support_nsh'] and
       $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/nsh-dpdk':
            command => '/usr/bin/curl http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu/install.sh | /bin/bash -s nshdpdk'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/dpdk':
            command => '/usr/bin/curl http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu/install.sh | /bin/bash -s dpdk'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_nsh'] {
        exec { 'install ovs/nsh':
            command => '/usr/bin/curl http://10.20.0.2:8080/plugins/fuel-plugin-ovs-0.9/repositories/ubuntu/install.sh | /bin/bash -s nsh'
        }
    }

} elsif $operatingsystem == 'CentOS' {
}
