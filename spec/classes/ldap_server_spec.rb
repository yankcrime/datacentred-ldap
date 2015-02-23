require 'spec_helper'

describe 'ldap::server' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ldap::server class without any additional parameters" do
          let(:params) do
            {
              :suffix => 'dc=example,dc=com',
              :rootdn => 'cn=admin,dc=example,dc=com',
              :rootpw => 'llama123',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ldap::params') }
          it { is_expected.to contain_class('ldap::server::install').that_comes_before('ldap::server::config') }
          it { is_expected.to contain_class('ldap::server::config') }
          it { is_expected.to contain_class('ldap::server::service').that_subscribes_to('ldap::server::config') }

          it { is_expected.to contain_service('ldap-server') }
          it { is_expected.to contain_package('ldap-server').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ldap::server class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('slapd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
