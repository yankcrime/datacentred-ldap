require 'spec_helper'

describe 'ldap::server', :type => :class do
  let(:params) { {
    :suffix => 'dc=example,dc=com',
    :rootdn => 'cn=admin,dc=example,dc=com',
    :rootpw => 'llama123'
  }}

  context 'on Debian' do
    let(:facts) { {
      :osfamily => 'Debian',
      :lsbdistid => 'debian',
      :lsbdistcodename => 'squeeze'
    }}

    context 'with no parameters' do
      it { should compile.with_all_deps }

      it { should contain_package('ldap-server').with(
        :ensure => 'present',
        :name   => 'slapd'
      )}

      it { should contain_service('ldap-server').with(
        :ensure => 'running',
        :enable => true,
        :name   => 'slapd'
      )}

      it { should contain_file('/etc/ldap/slapd.conf').with(
        :owner   => '0',
        :group   => '0',
        :mode    => '0644'
      )}

      it { should contain_file('/etc/default/slapd').with(
        :owner   => '0',
        :group   => '0',
        :mode    => '0644'
      )}
    end

    context 'with a custom package name' do
      let(:params) { super().merge('package_name' => 'dave') }
      it { should contain_package('ldap-server').with_name('dave') }
    end

    context 'with the package at a latest version' do
      let(:params) { super().merge('package_ensure' => 'latest') }
      it { should contain_package('ldap-server').with_ensure('latest') }
    end

    context 'with service management disabled' do
      let(:params) { super().merge('service_manage' => 'false') }
      it { should_not contain_service('ldap-server') }
    end

    context 'with a custom service name' do
      let(:params) { super().merge('service_name' => 'dave') }
      it { should contain_service('ldap-server').with_name('dave') }
    end

    context 'with the service disabled' do
      let(:params) { super().merge('service_enable' => 'false') }
      it { should contain_service('ldap-server').with_enable(false) }
    end

    context 'with the service stopped' do
      let(:params) { super().merge('service_ensure' => 'stopped') }
      it { should contain_service('ldap-server').with_ensure('stopped') }
    end

    context 'with a custom config file' do
      let(:params) { super().merge('config_file' => '/etc/dave.conf') }
      it { should contain_file('/etc/dave.conf')}
    end

    context 'with ssl enabled and no files specified' do
      let(:params) { super().merge('ssl' => true) }
      it do
        expect { should compile }.to raise_error
      end
    end

  end
end
