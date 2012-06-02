class boxes::developmentbox {

    Exec {
      path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
      logoutput => true,
    }

    # the update
    include apt::update

    #Package [require => Exec['apt_update']]
    Exec["apt_update"] -> Package <| |>

    # put here your tools
    $package_list = ['vim', 'aptitude', 'sudo', 'mc', 'screen']

    package {$package_list:
        ensure => present
    }


#    php::module { 'xdebug':
#        require => Apt::Sources_list['dotdeb-php53'],
#        notify  => Service['apache'],
#        source  => true,
#    }
}