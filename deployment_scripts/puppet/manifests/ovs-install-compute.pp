$fuel_settings = parseyaml(file('/etc/compute.yaml'))
if $operatingsystem == 'Ubuntu' {
    if $fuel_settings['fuel-plugin-ovs']['support_dpdk'] {
        $packages='openvswitch-datapath-dkms_2.4.90.dpdk-1 openvswitch-common_2.4.90.dpdk-1 openvswitch-switch_2.4.90.dpdk-1'
    }
    if $fuel_settings['fuel-plugin-ovs']['support_nsh'] {
        $packages='openvswitch-datapath-dkms_2.4.90.nsh-1 openvswitch-common_2.4.90.nsh-1  openvswitch-switch_2.4.90.nsh-1'
    }
    if $fuel_settings['fuel-plugin-ovs']['support_nsh_dpdk'] {
        $packages='openvswitch-datapath-dkms_2.4.90.nshdpdk-1 openvswitch-common_2.4.90.nshdpdk-1 openvswitch-switch_2.4.90.nshdpdk-1'
    }
    exec { 'ovs install':
        command => '/usr/bin/apt-get -y --force-yes install $packages'
    }
} elsif $operatingsystem == 'CentOS' {
}
