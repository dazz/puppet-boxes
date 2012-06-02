class boxes::developmentbox {

    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ] }

    # untested until comment removed
    package {'developer_tools':
        require => Package['mc', 'aptitude', 'vim'],
        ensure => present
     }

#    php::module { 'xdebug':
#        require => Apt::Sources_list['dotdeb-php53'],
#        notify  => Service['apache'],
#        source  => true,
#    }
}