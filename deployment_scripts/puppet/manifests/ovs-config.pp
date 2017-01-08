notice('MODULAR: ovs-config.pp')
# get options
$ovs_settings   = hiera('fuel-plugin-ovs')
$dpdk           = hiera_hash('dpdk', {})

$install_dpdk   = $ovs_settings['install_dpdk']
$ovs_socket_mem = join(pick($dpdk['ovs_socket_mem'], []), ',')
$ovs_pmd_core_mask = $dpdk['ovs_pmd_core_mask']

if $operatingsystem == 'Ubuntu' {
  if (!roles_include(['primary-controller', 'controller'])) or $install_on_controller {
      exec { 'install ovs_nsh_dpdk':
          command => "/etc/fuel/plugins/fuel-plugin-ovs-1.0/config.sh ${install_dpdk} ${ovs_socket_mem} ${ovs_pmd_core_mask}",
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      }
    }
} elsif $operatingsystem == 'CentOS' {
}
