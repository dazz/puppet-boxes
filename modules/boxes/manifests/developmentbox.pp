class boxes::developmentbox {

    # untested until comment removed
    package {'developer_tools':
        require => Package['mc', 'aptitude', 'vim'],
        ensure => present
     }
}