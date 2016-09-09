# get options
$master_ip      = hiera('master_ip')
$ovs_settings   = hiera('fuel-plugin-ovs')
$dpdk           = hiera('dpdk')

$install_nsh    = $ovs_settings['install_nsh']
$install_dpdk   = $ovs_settings['install_dpdk']
$soc_mem        = pick($dpdk['ovs_socket_mem'], [])
$ovs_socket_mem = join($soc_mem, ',')

# Sum of hugepages for dpdk
# We are using 2MB size so divide by 2 and round up
$allocate       = inline_template('<%= (@soc_mem.reduce(0, :+)/2.to_f).ceil %>')


if $operatingsystem == 'Ubuntu' {
    exec { 'install ovs_nsh_dpdk':
        command => "curl http://${master_ip}:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | bash -s ${master_ip} ${install_nsh} ${install_dpdk} ${ovs_socket_mem} ${allocate}",
        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
    }
} elsif $operatingsystem == 'CentOS' {
}
