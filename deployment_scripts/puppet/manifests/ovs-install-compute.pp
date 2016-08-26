# get options
$master_ip    = hiera('master_ip')
$ovs_settings = hiera('fuel-plugin-ovs')
$hugepages    = hiera('hugepages', [])

$install_nsh  = $ovs_settings['install_nsh']
$install_dpdk = $ovs_settings['install_dpdk']


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

      File[$dev_hugepages] -> Mount[$dev_hugepages] -> Exec['install ovs_nsh_dpdk']
    }

    exec { 'install ovs_nsh_dpdk':
        command => "curl http://${master_ip}:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | bash -s ${master_ip} ${install_nsh} ${install_dpdk}",
        path   => "/usr/bin:/usr/sbin:/bin:/sbin";
    }
} elsif $operatingsystem == 'CentOS' {
}
