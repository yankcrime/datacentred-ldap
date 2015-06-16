require 'spec_helper'

describe 'ldap::client' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ldap::client class without any additional parameters" do
          let(:params) do
            {
              :uri  => 'ldap://localhost',
              :base => 'dc=example,dc=com',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ldap::params') }
          it { is_expected.to contain_class('ldap::client::install').that_comes_before('ldap::client::config') }
          it { is_expected.to contain_class('ldap::client::config') }

          it { is_expected.to contain_package('ldap-client').with_ensure('present') }
          it { is_expected.to contain_package('net-ldap').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ldap::client class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('slapd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
