class boxes::setupbox {

    notice("boxes::setupbox install apache and php")
    apache::php

    # install additional php packages
    package{ ["php5-intl","php5-mysql","phpunit"]:
        ensure => "installed",
        require => Class["apache::php"],
    }

    # TODO: include augeas module
    # installs augtool
    # include augeas

    # add user vagrant to group www-data
    user { "vagrant":
        groups => "www-data",
    }

    notice("boxes::setupbox install mysql")
    include mysql::server

}