$fuel_settings = parseyaml(file('/etc/astute.yaml'))
if $operatingsystem == 'Ubuntu' {
    if $fuel_settings['fuel-plugin-ovs']['support_nsh'] and
       $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/nsh-dpdk':
            command => '/usr/bin/apt-get -y --force-yes install openvswitch-datapath-dkms_2.4.90.nshdpdk-1 openvswitch-common_2.4.90.nshdpdk-1 openvswitch-switch_2.4.90.nshdpdk-1'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        exec { 'install ovs/dpdk':
            command => '/usr/bin/apt-get -y --force-yes install openvswitch-datapath-dkms_2.4.90.dpdk-1 openvswitch-common_2.4.90.dpdk-1 openvswitch-switch_2.4.90.dpdk-1'
        }
    }
    elsif $fuel_settings['fuel-plugin-ovs']['support_nsh'] {
        exec { 'install ovs/nsh':
            command => '/usr/bin/apt-get -y --force-yes install openvswitch-datapath-dkms_2.4.90.nsh-1 openvswitch-common_2.4.90.nsh-1  openvswitch-switch_2.4.90.nsh-1'
        }
    }

} elsif $operatingsystem == 'CentOS' {
}
