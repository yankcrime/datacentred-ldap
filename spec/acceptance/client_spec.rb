require 'spec_helper_acceptance'

describe 'ldap::client class' do

  context 'required parameters' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'ldap::client':
          uri  => 'ldap://localhost',
          base => 'dc=example,dc=com',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('libldap-2.4-2') do
      it { is_expected.to be_installed }
    end
  end

end
