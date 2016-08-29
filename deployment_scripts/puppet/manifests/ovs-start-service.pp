$fuel_settings = parseyaml(file('/etc/astute.yaml'))
$install_dpdk = $::fuel_settings['fuel-plugin-ovs']['install_dpdk']
if $operatingsystem == 'Ubuntu' {
    unless empty($hugepages) {
       $dev_hugepages = '/dev/hugepages'

       file { $dev_hugepages:
           ensure  => 'directory',
       }

       mount { $dev_hugepages:
           ensure  => mounted,
           device  => 'none'
           fstype  => 'hugetlbfs',
       }
    }

    if $install_dpdk == 'true' {

        exec { 'start ovs service':
            command => "service openvswitch-switch start",
            path   => "/usr/bin:/usr/sbin:/bin:/sbin";
        }
    }
} elsif $operatingsystem == 'CentOS' {
}
