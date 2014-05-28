require 'spec_helper'

describe 'ldap::client', :type => :class do
  let(:params) { {
    :uri  => 'ldap://localhost',
    :base => 'dc=example,dc=com',
  }}

  context 'on Debian' do
    let(:facts) { {
      :osfamily => 'Debian',
      :lsbdistid => 'debian',
      :lsbdistcodename => 'squeeze'
    }}

    context 'with no parameters' do
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
        expect { should compile }.to raise_error(Puppet::Error, /ssl/)
      end
    end

  end
end
