$fuel_settings = parseyaml(file('/etc/astute.yaml'))
$master_ip = $::fuel_settings['master_ip']
if $operatingsystem == 'Ubuntu' {
    if $fuel_settings['fuel-plugin-ovs']['support_nsh'] and
       $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/nsh-dpdk':
            command => '/usr/bin/curl http://$master_ip:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | /bin/bash -s $master_ip nshdpdk'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/dpdk':
            command => '/usr/bin/curl http://$master_ip:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | /bin/bash -s $master_ip dpdk'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_nsh'] {
        exec { 'install ovs/nsh':
            command => '/usr/bin/curl http://$master_ip:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | /bin/bash -s $master_ip nsh'
        }
    }

} elsif $operatingsystem == 'CentOS' {
}
