class boxes::setupbox {

    # the update
    Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
    include apt::update
    #Package [require => Exec['apt_update']]
    Exec["apt_update"] -> Package <| |>

    # your stuff here

    # installs augtool for modifying config files (not sure if needed)
    include augeas

    # installs apache and php
    apache::php

    # additional php-packages
    package{ ["php5-intl","php5-mysql"]:
      ensure => "installed",
      require => Class["apache::php"],
    }

    # add user vagrant to group www-data
    user { "vagrant":
      groups => "www-data",
    }

    # include mysql server
    include mysql::server
}