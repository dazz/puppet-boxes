class boxes::developmentbox {

    # install xdebug
    include xdebug

    # install sqlite
    include sqlite

    # install phpunit
    package{ ["phpunit"]:
        ensure => "installed",
        require => Class["apache::php"],
    }

    # untested until comment removed
    package {'developer_tools':
        require => Package['mc', 'aptitude', 'vim'],
        ensure => present
     }
}