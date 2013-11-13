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
class{'apache':
  default_vhost     => false,
  default_ssl_vhost => true,
}
include apaxy
apaxy::theme{'test':
  manage_vhost => true,
}
