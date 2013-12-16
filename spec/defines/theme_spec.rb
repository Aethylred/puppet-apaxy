require 'spec_helper'
describe 'apaxy::theme', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily         => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    let :pre_condition do 
      'include apache'
    end
    let :title do
      'rspec'
    end
    describe "with no parameters" do
      it { should include_class('apaxy::params') }
      it { should contain_file('rspec_apaxy_theme_dir').with(
        'ensure'  => 'directory',
        'path'    => '/var/www/theme',
        'recurse' => true,
        'replace' => false,
        'source'  => '/var/opt/apaxy/apaxy/theme',
        'require' => 'File[apaxy_theme_dir]'
      ) }
      it { should contain_file('rspec_apaxy_htaccess').with(
        'ensure'  => 'file',
        'path'    => '/var/www/.htaccess',
        'require' => 'File[rspec_apaxy_theme_dir]',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_file('rspec_apaxy_header').with(
        'ensure'  => 'file',
        'path'    => '/var/www/theme/header.html',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should contain_file('rspec_apaxy_footer').with(
        'ensure'  => 'file',
        'path'    => '/var/www/theme/footer.html',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should_not contain_apache__vhost('apaxy-rspec')}
    end
    describe 'with $docroot => /some/other/path' do
      let :params do
        {
          :docroot => '/some/other/path',
        }
      end
      it { should contain_file('rspec_apaxy_theme_dir').with(
        'ensure'  => 'directory',
        'path'    => '/some/other/path/theme',
        'recurse' => true,
        'replace' => false,
        'source'  => '/var/opt/apaxy/apaxy/theme',
        'require' => 'File[apaxy_theme_dir]'
      ) }
      it { should contain_file('rspec_apaxy_htaccess').with(
        'ensure'  => 'file',
        'path'    => '/some/other/path/.htaccess',
        'require' => 'File[rspec_apaxy_theme_dir]',
        'notify'  => 'Service[httpd]'
      ) }
      it { should contain_file('rspec_apaxy_header').with(
        'ensure'  => 'file',
        'path'    => '/some/other/path/theme/header.html',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should contain_file('rspec_apaxy_footer').with(
        'ensure'  => 'file',
        'path'    => '/some/other/path/theme/footer.html',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should_not contain_apache__vhost('apaxy-rspec')}
    end
    describe 'with $header_source => puppet:///some/other/path' do
      let :params do
        {
          :header_source => 'puppet:///some/other/path',
        }
      end
      it { should contain_file('rspec_apaxy_header').with(
        'ensure'  => 'file',
        'path'    => '/var/www/theme/header.html',
        'source'  => 'puppet:///some/other/path',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
    end
    describe 'with custom $header_fragment' do
      let :params do
        {
          :header_fragment => 'Inserted into header',
        }
      end
      it { should contain_file('rspec_apaxy_header').with(
        'ensure'  => 'file',
        'path'    => '/var/www/theme/header.html',
        'require' => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should contain_file('rspec_apaxy_header').with_content(
        /-->$\n^Inserted into header$\Z/
      ) }
    end
    describe 'with $footer_source => puppet:///some/other/path' do
      let :params do
        {
          :footer_source => 'puppet:///some/other/path',
        }
      end
    end
    describe 'with custom $footer_fragment' do
      let :params do
        {
          :footer_fragment => 'Inserted into footer',
        }
      end
      it { should contain_file('rspec_apaxy_footer').with_content(
        /"block">$\n^Inserted into footer$\n^  <\/div>/
      ) }
    end
    describe 'with additional $attribution' do
      let :params do
        {
          :attribution => 'Inserted into attribution',
        }
      end
      it { should contain_file('rspec_apaxy_footer').with_content(
        /-->$\n^<p>Inserted into attribution<\/p>$\n^  <p>This/
      ) }
    end
    describe 'with $manage_vhost => true' do
      let :params do
        {
          :manage_vhost => true,
        }
      end
      it { should contain_apache__vhost('apaxy-rspec').with(
        'port'            => '80',
        'docroot'         => '/var/www',
        'scriptalias'     => '/usr/lib/cgi-bin',
        'serveradmin'     => 'root@localhost',
        'access_log_file' => 'apaxy-rspec_access.log',
        'error_log_file'  => 'apaxy-rspec_error.log',
        'priority'        => '15',
        'before'          => 'File[rspec_apaxy_theme_dir]'
      ) }
      it { should contain_apache__vhost('apaxy-rspec').with_directories(
        'path'            => '/var/www',
        'allow_override'  => ['all'],
        'directoryindex'  => 'disabled'
      ) }
    end
  end

  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily   => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    let :pre_condition do 
            "include apache"
    end
    let :title do
      'rspec'
    end
    describe "with no parameters" do
      it { should include_class('apaxy::params') }
    end
  end

end