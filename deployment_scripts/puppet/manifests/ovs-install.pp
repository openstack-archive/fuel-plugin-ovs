notice('MODULAR: ovs-install.pp')
# get options
$master_ip      = hiera('master_ip')
$ovs_settings   = hiera('fuel-plugin-ovs')
$dpdk           = hiera_hash('dpdk', {})

$install_nsh    = $ovs_settings['install_nsh']
$install_dpdk   = $ovs_settings['install_dpdk']
$install_on_controller = $ovs_settings['install_on_controller']
$ovs_socket_mem = join(pick($dpdk['ovs_socket_mem'], []), ',')


if $operatingsystem == 'Ubuntu' {
  if (!roles_include(['primary-controller', 'controller'])) or $install_on_controller {
      exec { 'install ovs_nsh_dpdk':
          command => "curl http://${master_ip}:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | bash -s ${master_ip} ${install_nsh} ${install_dpdk} ${ovs_socket_mem}",
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      }
    }
} elsif $operatingsystem == 'CentOS' {
}
