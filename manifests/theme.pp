# The apaxy::theme resource deploys the apaxy theme into the
# documentroot of a HTTP file directory
define apaxy::theme (
  $docroot        = $::apache::docroot,
  $header_source  = undef,
  $footer_source  = undef,
  $manage_vhost   = undef
){
  require apaxy

  # docroot in name to ensure resources are unique

  file{"${title}_apaxy_theme_dir":
    ensure  => directory,
    path    => "${docroot}/theme",
    recurse => true,
    replace => false,
    source  => $apaxy::theme_dir,
    require => File['apaxy_theme_dir'],
  }

  file{"${title}_apaxy_htaccess":
    ensure  => file,
    path    => "${docroot}/.htaccess",
    content => template('apaxy/htaccess.erb'),
    require => File["${title}_apaxy_theme_dir"],
    notify  => Service['httpd'],
    }

  if $header_source {
    file{"${title}_apaxy_header":
      ensure  => file,
      path    => "${docroot}/theme/header.html",
      source  => $header_source,
      require => File["${title}_apaxy_theme_dir"],
    }
  } else {
    file{"${title}_apaxy_header":
      ensure  => file,
      path    => "${docroot}/theme/header.html",
      content => template('apaxy/header.html.erb'),
      require => File["${title}_apaxy_theme_dir"],
    }
  }

  if $footer_source {
    file{"${title}_apaxy_footer":
      ensure  => file,
      path    => "${docroot}/theme/footer.html",
      source  => $footer_source,
      require => File["${title}_apaxy_theme_dir"],
    }
  } else {
    file{"${title}_apaxy_footer":
      ensure  => file,
      path    => "${docroot}/theme/footer.html",
      content => template('apaxy/footer.html.erb'),
      require => File["${title}_apaxy_theme_dir"],
    }
  }

  if $manage_vhost {
    apache::vhost { "apaxy-${title}":
      port            => 80,
      docroot         => $docroot,
      scriptalias     => $apache::scriptalias,
      serveradmin     => $apache::serveradmin,
      access_log_file => "apaxy-${title}_access.log",
      error_log_file  => "apaxy-${title}_error.log",
      directories     => [
        {
          path            => $docroot,
          allow_override  => ['all'],
          directoryindex  => 'disabled',
        },  
      ],
      priority        => '15',
      before          => File["${title}_apaxy_theme_dir"],
    }
  }

}