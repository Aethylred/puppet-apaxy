define apaxy::theme (
  $docroot        = $apaxy::params::docroot,
  $header_source  = undef,
  $footer_source  = undef,
  $directory      = undef,
  $manage_vhost   = undef
){
  require apaxy

  # docroot in name to ensure resources are unique

  file{"${docroot}_theme":
    ensure  => directory,
    path    => "${docroot}/theme",
    recurse => true,
    replace => false,
    source  => $apaxy::theme_dir,
    require => File['apaxy_theme_dir'],
  }

  file{"${docroot}_htaccess":
    ensure  => file,
    path    => "${docroot}/.htaccess",
    content => template('apaxy/htaccess.erb'),
    require => File["${docroot}_theme"],
    notify  => Service['httpd'],
    }

  if $header_source {
    file{"${docroot}_header":
      ensure  => file,
      path    => "${docroot}/theme/header.html",
      source  => $header_source,
      require => File["${docroot}_theme"],
    }
  } else {
    file{"${docroot}_header":
      ensure  => file,
      path    => "${docroot}/theme/header.html",
      content => template('apaxy/header.html.erb'),
      require => File["${docroot}_theme"],
    }
  }

  if $footer_source {
    file{"${docroot}_footer":
      ensure  => file,
      path    => "${docroot}/theme/footer.html",
      source  => $footer_source,
      require => File["${docroot}_theme"],
    }
  } else {
    file{"${docroot}_footer":
      ensure  => file,
      path    => "${docroot}/theme/footer.html",
      content => template('apaxy/footer.html.erb'),
      require => File["${docroot}_theme"],
    }
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