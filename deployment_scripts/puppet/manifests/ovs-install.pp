notice('MODULAR: ovs-install.pp')

$ovs_settings   = hiera('fuel-plugin-ovs')
$install_nsh    = $ovs_settings['install_nsh']
$install_dpdk   = $ovs_settings['install_dpdk']
$install_on_controller = $ovs_settings['install_on_controller']

if $operatingsystem == 'Ubuntu' {
  if (!roles_include(['primary-controller', 'controller'])) or $install_on_controller {
      exec { 'install ovs_nsh_dpdk':
          command => "/etc/fuel/plugins/fuel-plugin-ovs-1.0/install.sh ${install_nsh} ${install_dpdk}",
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      }
    }
} elsif $operatingsystem == 'CentOS' {
}
