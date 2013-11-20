# apaxy

[![Build Status](https://travis-ci.org/Aethylred/puppet-apaxy.png?branch=master)](https://travis-ci.org/Aethylred/puppet-apaxy)

This Puppet module installs and configures a HTTP file directory with the [Apaxy](http://adamwhitcroft.com/apaxy/) theme.

# Usage

## Apaxy on the document root

The following puppet code will put Apaxy on the root document of a web server, replacing the default web site.

```puppet
class{'apache':
  default_vhost     => false,
  default_ssl_vhost => true,
}
include apaxy
apaxy::theme{'default':
  manage_vhost => true,
}
```
# Resources

## apaxy

The `apaxy` class uses git to clone a local repository of Apaxy from a repository. An alternative repository or git revision can be specified by parameters.

### Parameters

* *install_dir*: setting this will change where Apaxy is cloned to. The default is to use `/var/opt/apaxy`
* *source*: setting this will change the source URI used by git to clone Apaxy. The default is to use the [Apaxy Github repository](https://github.com/AdamWhitcroft/Apaxy)
* *revision*: This can be set to a branch name, tag or commit hash to specify which revision of the Apaxy repository is to be cloned. It defaults to the head of the `master` branch.

## apaxy::theme

The `apaxy::theme` resource copies the clone from the local repository created by the `apaxy` class into a directory of a web site. Currently it applies the apaxy theme by putting a `.htaccess` file into the specified directory. These should really be in the site `vhost.conf` file, but the [Puppetlabs Apache Module](https://github.com/puppetlabs/puppetlabs-apache) is not yet complete enough to do this. Fortunatly, when this changes the module will transparently change this over.

### Parameters

* *docroot*: this is the toplevel root directory where the Apaxy theme is to be installed. The Apaxy theme will apply to this directory and all it's subdirectories. By default it will be applied to the document root specified by the `docroot` of the `apache` class from the [Puppetlabs Apache Module](https://github.com/puppetlabs/puppetlabs-apache), which is OS dependent.
* *header_source*: Setting this will replace the default `header.html` template with the file from the specified source. This `source` parameter is handled as the [`source` attribute of the puppet `file` resource](http://docs.puppetlabs.com/references/latest/type.html#file-attribute-source).
* *footer_source*: Setting this will replace the default `footer.html` template with the file from the specified source. This `source` parameter is handled as the [`source` attribute of the puppet `file` resource](http://docs.puppetlabs.com/references/latest/type.html#file-attribute-source).
* *manage_vhost*: If this is set to true, the `apaxy::theme` resource will create an `apaxy::vhost` which will deploy and enable the Apaxy site.

# Custom vhost

There must be an `AllowOverride all` declaration in  an Apaxy site's `vhost.conf` to enable the Apaxy theme. This should appear in the `<Directory $docroot>` block, where `$docroot` matches what's passed as the *docroot* parameter to `apaxy::theme`. This `vhost.conf` file should be managed by using the `apache::vhost` resource from the [Puppetlabs Apache Module](https://github.com/puppetlabs/puppetlabs-apache). An example `apache::vhost` declaration is given below:

```puppet
class{'apache':
  default_vhost     => false,
  default_ssl_vhost => true,
}
include apaxy
apaxy::theme{'default': }
apache::vhost { 'default':
  port            => 80,
  docroot         => $docroot,
  access_log_file => 'apaxy_access.log',
  directories     => [
    {
      path           => $docroot,
      allow_override => ['all'],
    },
  ],
  priority        => '15',
  require => Apaxy::Theme['default'],
}
```

# Dependencies

* [Puppetlabs Apache Module](https://github.com/puppetlabs/puppetlabs-apache)
* [Puppetlabs vcsrepo Module](https://github.com/puppetlabs/puppetlabs-vcsrepo)
* [Git](http://git-scm.com/) either install the required packages or use a [Git Puppet Module](https://github.com/nesi/puppet-git)

# To Do

* Remove the need for a `.htaccess` file and incorporate the Apaxy configuration directly into the site `vhost.conf` file. Needs `Alias` and `AliasMatch` directives to be properly implemented into the [Puppetlabs Apache Module](https://github.com/puppetlabs/puppetlabs-apache), see [#483](https://github.com/puppetlabs/puppetlabs-apache/pull/483) and it's corresponding [pull request](https://github.com/puppetlabs/puppetlabs-apache/pull/483).

# Attribution

The puppet-apaxy module was written by Aaron Hicks (2013).

## Apaxy

[Apaxy](http://adamwhitcroft.com/apaxy/) was written and is maintained by [Adam Whitcroft](https://twitter.com/adamwhitcroft).

## puppet-blank

This module is derived from the [puppet-blank](https://github.com/Aethylred/puppet-blank) module by Aaron Hicks (aethylred@gmail.com)

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

## rspec-puppet-augeas

This module includes the [Travis](https://travis-ci.org) configuration to use [`rspec-puppet-augeas`](https://github.com/domcleal/rspec-puppet-augeas) to test and verify changes made to files using the [`augeas` resource](http://docs.puppetlabs.com/references/latest/type.html#augeas) available in Puppet. Check the `rspec-puppet-augeas` [documentation](https://github.com/domcleal/rspec-puppet-augeas/blob/master/README.md) for usage.

This will require a copy of the original input files to `spec/fixtures/augeas` using the same filesystem layout that the resource expects:

    $ tree spec/fixtures/augeas/
    spec/fixtures/augeas/
    `-- etc
        `-- ssh
            `-- sshd_config

# Gnu General Public License

[![GPL3](http://www.gnu.org/graphics/gplv3-127x51.png)](http://www.gnu.org/licenses)

This file is part of the apaxy Puppet module.

The apaxy Puppet module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The apaxy Puppet module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the apaxy Puppet module.  If not, see <http://www.gnu.org/licenses/>.
