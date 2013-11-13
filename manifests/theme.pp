define apaxy::theme (
  $docroot      = $apaxy::params::docroot,
  $directory    = undef,
  $manage_vhost = undef
){
  require apaxy

  # docroot in name to ensure resources are unique

  file{"${docroot}_theme":
    ensure  => link,
    path    => "${docroot}/theme",
    target  => $apaxy::theme_dir,
    require => File['apaxy_theme_dir'],
  }

  file{"${docroot}_htaccess":
    ensure  => file,
    path    => "${docroot}/.htaccess",
    content => template('apaxy/htaccess.erb'),
    require => File["${docroot}_theme"],
    notify  => Service['httpd'],
  }

  if $manage_vhost {
    apache::vhost { 'apaxy':
      port            => 80,
      docroot         => $docroot,
      scriptalias     => $apache::scriptalias,
      serveradmin     => $apache::serveradmin,
      access_log_file => "apaxy_access.log",
      directories => [
        { path => $docroot, allow_override => ['all'] },
      ],
      priority        => '15',
    }
  }

}