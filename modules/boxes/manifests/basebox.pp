class boxes::basebox {

  Exec {
    path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    logoutput => true,
  }

  # the update
  include apt::update

  Package [require => Exec['apt_update']]
  # Exec["apt_update"] -> Package <| |>

  # your basebox packages here
  $package_list = ['vim', 'aptitude', 'sudo', 'mc']

  package {$package_list: }


}

