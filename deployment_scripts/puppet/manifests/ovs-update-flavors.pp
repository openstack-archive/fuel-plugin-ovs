# get options
$master_ip      = hiera('master_ip')

if $operatingsystem == 'Ubuntu' {
    exec { 'update flavors':
        command => "curl http://${master_ip}:8080/plugins/fuel-plugin-ovs-0.9/deployment_scripts/update_flavors.sh | bash -s",
        path   => "/usr/bin:/usr/sbin:/bin:/sbin",
    }
} elsif $operatingsystem == 'CentOS' {
}
