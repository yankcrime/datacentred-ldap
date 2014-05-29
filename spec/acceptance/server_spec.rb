require 'spec_helper_acceptance'

describe 'ldap server class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  case fact('osfamily')
  when 'RedHat'
    package_name = 'openldap-servers'
    service_name = 'slapd'
  when 'Debian'
    package_name = 'slapd'
    service_name = 'slapd'
  end
  
  context 'required parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'ldap::server':
          suffix => 'dc=example,dc=com',
          rootdn => 'cn=admin,dc=example,dc=com',
          rootpw => 'llama123',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
