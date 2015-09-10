require 'spec_helper_acceptance'

describe 'ldap::server class' do

  suffix = 'dc=example,dc=com'
  rootdn = 'cn=admin,dc=example,dc=com'
  rootpw = 'llama123'

  ldap_entry_defaults = <<-EOS
    Ldap_entry {
      host       => 'localhost',
      port       => 389,
      ssl        => false,
      base       => '#{suffix}',
      username   => '#{rootdn}',
      password   => '#{rootpw}',
    }
  EOS

  context 'required parameters' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'ldap::server':
          suffix => '#{suffix}',
          rootdn => '#{rootdn}',
          rootpw => '#{rootpw}',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('slapd') do
      it { is_expected.to be_installed }
    end

    describe service('slapd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'schema' do
    it 'should create a schema idempotently' do
      pp = <<-EOS
        #{ldap_entry_defaults}
        ldap_entry { '#{suffix}':
          attributes => {
            'objectClass' => [
              'dcObject',
              'organization',
            ],
            'dc'          => 'example',
            'o'           => 'example.com',
          },
        } ->
        ldap_entry { 'ou=people,#{suffix}':
          attributes => {
            'objectClass' => [
              'top',
              'organizationalUnit',
            ],
            'ou'          => 'people',
          },
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end
  end

  context 'user' do
    it 'should create a user with mutable password idempotently' do
      pp = <<-EOS
        #{ldap_entry_defaults}
        ldap_entry { 'cn=test,ou=people,#{suffix}':
          attributes => {
            'objectClass'  => [
              'person',
            ],
            'cn'           => 'test',
            'sn'           => 'test',
            'userPassword' => '{CRYPT}$1$AtrY7YzK$ntxY68O7XvV6mlKy50zT31',
          },
          mutable    => [
            'userPassword',
          ],
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end
  end

end
