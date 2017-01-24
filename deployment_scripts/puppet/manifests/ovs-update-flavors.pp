notice('MODULAR: ovs-update-flavors.pp')
if $operatingsystem == 'Ubuntu' {
    exec { 'update flavors':
        command => "/etc/fuel/plugins/fuel-plugin-ovs-1.0/update_flavors.sh",
        path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    }
} elsif $operatingsystem == 'CentOS' {
}
