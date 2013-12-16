require 'spec_helper'
describe 'apaxy', :type => :class do
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
            "include apache"
    end
    describe "with no parameters" do
      it { should contain_class('apaxy::params') }
      it { should contain_vcsrepo('apaxy').with(
        'ensure'    => 'present',
        'provider'  => 'git',
        'path'      => '/var/opt/apaxy',
        'source'    => 'https://github.com/AdamWhitcroft/Apaxy.git',
        'revision'  => 'master'
      ) }
      it { should contain_file('apaxy_theme_dir').with(
        'ensure'  => 'directory',
        'path'    => '/var/opt/apaxy/apaxy/theme',
        'require' => 'Vcsrepo[apaxy]'
      ) }
      it { should contain_file('apaxy_theme_htaccess').with(
        'ensure'  => 'file',
        'path'    => '/var/opt/apaxy/apaxy/theme/.htaccess',
        'content' => 'Options -Indexes',
        'require' => 'File[apaxy_theme_dir]'
      )}
    end
    describe "with install_dir => /some/other/path" do
      let :params do
        {
          :install_dir => '/some/other/path',
        }
      end
      it { should contain_vcsrepo('apaxy').with(
        'ensure'    => 'present',
        'provider'  => 'git',
        'path'      => '/some/other/path',
        'source'    => 'https://github.com/AdamWhitcroft/Apaxy.git',
        'revision'  => 'master'
      ) }
      it { should contain_file('apaxy_theme_dir').with(
        'ensure'  => 'directory',
        'path'    => '/some/other/path/apaxy/theme',
        'require' => 'Vcsrepo[apaxy]'
      ) }
      it { should contain_file('apaxy_theme_htaccess').with(
        'ensure'  => 'file',
        'path'    => '/some/other/path/apaxy/theme/.htaccess',
        'content' => 'Options -Indexes',
        'require' => 'File[apaxy_theme_dir]'
      )}
    end
    describe "with source => http://example.org/apaxy.git" do
      let :params do
        {
          :source => 'http://example.org/apaxy.git',
        }
      end
      it { should contain_vcsrepo('apaxy').with(
        'ensure'    => 'present',
        'provider'  => 'git',
        'path'      => '/var/opt/apaxy',
        'source'    => 'http://example.org/apaxy.git',
        'revision'  => 'master'
      ) }
    end
    describe "with revision => not-master" do
      let :params do
        {
          :revision => 'not-master',
        }
      end
      it { should contain_vcsrepo('apaxy').with(
        'ensure'    => 'present',
        'provider'  => 'git',
        'path'      => '/var/opt/apaxy',
        'source'    => 'https://github.com/AdamWhitcroft/Apaxy.git',
        'revision'  => 'not-master'
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
    describe "with no parameters" do
      it { should contain_class('apaxy::params') }
    end
  end

  context "on an Unknown OS" do
    let :facts do
      {
        :osfamily   => 'Unknown',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    # The Apache class fails first.
    # it do
    #   expect {
    #     should contain_class('puppet::params')
    #   }.to raise_error(Puppet::Error, /The apaxy class is not configured for Unknown distributions./)
    # end
  end

end