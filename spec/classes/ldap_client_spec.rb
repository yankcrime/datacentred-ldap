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
          it { is_expected.to contain_class('ldap::client::install').that_comes_before('Class[ldap::client::config]') }
          it { is_expected.to contain_class('ldap::client::config') }

          it { is_expected.to contain_package('ldap-client').with_ensure('present') }
          if Puppet.version.to_f < 4.0
              it { is_expected.to contain_package('net-ldap').with_ensure('present') }
          else
              it { is_expected.not_to contain_package('net-ldap').with_ensure('present') }
          end
          it do
            is_expected.to contain_file('ldap.conf')
              .with_content(/^TIMELIMIT\s+15$/)
          end
        end
        context 'ldap::client class with specific parameters' do
          let(:params) do
            {
              :uri          => 'ldap://localhost',
              :base         => 'dc=example,dc=com',
              :timelimit    => '',
              :sasl_nocanon => true
            }
          end
          # NOTE: this behaviour is directly related to PUP-5295
          it 'should contain TIMELIMIT directive set to 15 if undef' do
            params[:timelimit] = :undef
            is_expected.to contain_file('ldap.conf')
              .with_content(/^TIMELIMIT\s+15$/)
          end
          it 'should not contain TIMELIMIT directive if empty' do
            is_expected.to contain_file('ldap.conf')
              .without_content(/^TIMELIMIT\s+/)
          end
          it 'should contain SASL_NOCANON directive if set to true' do
            is_expected.to contain_file('ldap.conf')
              .with_content(/^SASL_NOCANON\s+on$/)
          end
          it 'should not contain SASL_NOCANON directive if set to false' do
            params[:sasl_nocanon] = false
            is_expected.to contain_file('ldap.conf')
              .without_content(/^SASL_NOCANON\s+$/)
          end
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
