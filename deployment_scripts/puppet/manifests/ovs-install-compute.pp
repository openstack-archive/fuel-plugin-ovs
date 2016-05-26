$fuel_settings = parseyaml(file('/etc/astute.yaml'))
$master_ip = $::fuel_settings['master_ip']
$install_nsh = $::fuel_settings['fuel-plugin-ovs']['install_nsh']
$install_dpdk = $::fuel_settings['fuel-plugin-ovs']['install_dpdk']
if $operatingsystem == 'Ubuntu' {
    exec { 'install ovs_nsh_dpdk':
        command => "curl http://${master_ip}:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/install.sh | bash -s ${master_ip} ${install_nsh} ${install_dpdk}",
        path   => "/usr/bin:/usr/sbin:/bin:/sbin";
    }
} elsif $operatingsystem == 'CentOS' {
}
