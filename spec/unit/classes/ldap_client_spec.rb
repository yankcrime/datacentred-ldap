require 'spec_helper'

describe 'ldap::client', :type => :class do
  let :params do
    {
      :uri  => 'ldap://localhost',
      :base => 'dc=example,dc=com',
    }
  end

  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily        => 'Debian',
        :lsbdistid       => 'debian',
        :lsbdistcodename => 'squeeze'
      }
    end

    it { should compile.with_all_deps }

    it { should contain_package('ldap-client').with(
      :ensure => 'present',
      :name   => 'libldap-2.4-2'
    )}

    it { should contain_package('net-ldap').with(
      :ensure   => 'present',
      :name     => 'net-ldap',
      :provider => 'gem'
    )}

    it { should contain_file('/etc/ldap/ldap.conf').with(
      :owner   => '0',
      :group   => '0',
      :mode    => '0644'
    )}
  end

  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
      }
    end

    it { should compile.with_all_deps }

    it { should contain_package('ldap-client').with(
      :ensure => 'present',
      :name   => 'openldap-clients'
    )}

    it { should contain_package('net-ldap').with(
      :ensure   => 'present',
      :name     => 'net-ldap',
      :provider => 'gem'
    )}

    it { should contain_file('/etc/openldap/ldap.conf').with(
      :owner   => '0',
      :group   => '0',
      :mode    => '0644'
    )}
  end

  context 'on all OSes' do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
      }
    end

    context 'with a custom package name' do
      let(:params) { super().merge('package_name' => 'dave') }
      it { should contain_package('ldap-client').with_name('dave') }
    end

    context 'with the package at a latest version' do
      let(:params) { super().merge('package_ensure' => 'latest') }
      it { should contain_package('ldap-client').with_ensure('latest') }
    end

    context 'with a custom config file' do
      let(:params) { super().merge('config_file' => '/etc/dave.conf') }
      it { should contain_file('/etc/dave.conf')}
    end

    context 'with ssl enabled and no certificate specified' do
      let(:params) { super().merge('ssl' => true) }
      it do
        expect { should compile }.to raise_error
      end
    end
  end
end
