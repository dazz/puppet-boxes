class boxes::basebox {

  # the update
  Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
  include apt::update
  #Package [require => Exec['apt_update']]
  Exec["apt_update"] -> Package <| |>

  # fix udev
  exec { "fix_udev_rules":
    command => "rm -f /etc/udev/rules.d/70-persistent-net.rules"
  }

  exec { "fix_udev_generator":
    command => "rm -f /lib/udev/rules.d/75-persistent-net-generator.rules"
  }

  # your stuff here
}

