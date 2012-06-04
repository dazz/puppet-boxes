class boxes::productionbox {

    # the update
    Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }
    include apt::update
    #Package [require => Exec['apt_update']]
    Exec["apt_update"] -> Package <| |>

    # your stuff here

    $projectname = "symfony"
    $targetdir = "/var/www"
    $projectdir = $targetdir/$projectname

    # url of symfony repo (this should not come over git)
    $downloadurl = "https://github.com/symfony/symfony-standard"

    exec { "download $projectname":
        command     => "git clone $downloadurl $projectdir",
        require     => Package["git-core"],
        creates     => "$projectdir",
        logoutput   => on_failure,
    }

    include apache
    # setup vhost
    apache::vhost { "$projectname.local":
      port     => 80,
      servername => '',
      #serveraliases => '',
      docroot  => $projectdir/web,
      template => 'apache/vhost-default.conf.erb'
    }

    $timezone='Europe/Berlin'


}