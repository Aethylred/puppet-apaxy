# This class defines the default parameters and variables
class apaxy::params {

  require apache

  # Using the docroot set on the Apache class is the correct thing to do
  $docroot      = $apache::docroot

  $install_dir  = '/var/opt/apaxy'
  $source       = 'https://github.com/AdamWhitcroft/Apaxy.git'

  case $::osfamily {
    Debian:{

    }
    RedHat:{

    }
    default:{
      fail("The apaxy class is not configured for ${::osfamily} distributions.")
    }
  }
}