# Class: apaxy
#
# This module manages apaxy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

# This file is part of the apaxy Puppet module.
#
#     The apaxy Puppet module is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     The apaxy Puppet module is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with the apaxy Puppet module.  If not, see <http://www.gnu.org/licenses/>.

# [Remember: No empty lines between comments and class definition]
class apaxy (
  $install_dir  = $apaxy::params::install_dir,
  $source       = $apaxy::params::source,
  $revision     = 'master'
) inherits apaxy::params {

  $theme_dir = "${install_dir}/apaxy/theme"

  vcsrepo{'apaxy':
    ensure    => 'present',
    provider  => 'git',
    path      => $install_dir,
    source    => $source,
    revision  => $revision,
  }

  file{'apaxy_theme_dir':
    ensure  => directory,
    path    => $theme_dir,
    require => Vcsrepo['apaxy']
  }

  file{'apaxy_theme_htaccess':
    ensure  => file,
    path    => "${theme_dir}/.htaccess",
    content => 'Options -Indexes',
    require => File['apaxy_theme_dir'],
  }

}
