class boxes::setupbox {

    notice("boxes::setupbox install php and apache2")
    include php::apache2

#    php::module { [ 'suhosin', ]:
#        require => Apt::Sources_list['dotdeb-php53'],
#        notify  => Service[$php::params::apache_service_name],
#        source  => true,
#    }

    package{"php5-intl":
        require => Class['php::install'],
        notify  => Service[$php::params::apache_service_name]
    }

    notice("boxes::setupbox install mysql")
    include mysql::server

}