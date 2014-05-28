require 'spec_helper_acceptance'

describe 'ldap server class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  
  context 'default parameters' do
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

    describe package('slapd') do
      it { should be_installed }
    end

    describe service('slapd') do
      it { should be_enabled }
      it { should be_running }
    end
  end

end
