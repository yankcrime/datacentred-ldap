# lib/puppet/type/ldap_schema_entry.rb
#
# Typical Usage:
#
# ldap_entry { 'cn=Foo,ou=Bar,dc=baz,dc=co,dc=uk':
#   ensure      => present,
#   host        => '1.2.3.4',
#   port        => 636,
#   base        => 'dc=baz,dc=co,dc=uk',
#   username    => 'cn=admin,dc=baz,dc=co,dc=uk',
#   password    => 'password',
#   attributes  => { givenName   => 'Foo',
#                    objectClass => ["top", "person", "inetorgPerson"]}
# }
#
# ldap_entry { 'cn=Foo,ou=Bar,dc=baz,dc=co,dc=uk':
#   ensure      => absent,
#   base        => 'dc=baz,dc=co,dc=uk',
#   host        => '1.2.3.4',
#   username    => 'cn=admin,dc=baz,dc=co,dc=uk',
#   password    => 'password',
# }
#
Puppet::Type.newtype(:ldap_entry) do
  @doc = 'Type to manage LDAP entries'

  ensurable

  newparam(:name) do
    desc 'Name of LDAP entry i.e. cn=Foo,ou=Bar,dc=baz,dc=co,dc=uk'
    isnamevar
  end

  newparam(:host) do
    desc 'Host Address (FQDN or IP) of the LDAP server'
  end

  newparam(:base) do
    desc 'LDAP tree base i.e. dc=foo,dc=co,dc=uk'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'ldap_entry::base is not a string'
      end
    end
  end

  newparam(:port) do
    desc  'Port of the LDAP server (default 389)'
    defaultto 636
    validate do |value|
      unless (1..65535).include?(value.to_i)
        raise ArgumentError, 'ldap_entry::port is not a whole number in the range 1-65535'
      end
    end
  end

  newparam(:username) do
    desc 'Username of admin account on LDAP server'
    defaultto 'admin'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'ldap_entry::username is not a string'
      end
    end
  end

  newparam(:password) do
    desc 'Password of admin account on LDAP server'
    validate do |value|
      unless value.is_a? String
        raise ArgumentError, 'ldap_entry::password is not a string'
      end
    end
  end

  newparam(:attributes) do
    desc 'LDAP entry attributes as a hash i.e. { :givenName => "Foo",
                                                 :objectClass =>
                                                   ["top", "person", "inetorgPerson"]}'
    validate do |value|
      unless value.is_a? Hash
        raise ArgumentError, 'ldap_entry::attributes is not a hash'
      end
    end
  end

  newparam(:self_signed) do
    desc 'Whether the LDAP server certificate is self-signed'
    defaultto false
  end

  newparam(:ssl) do
    desc 'Whether the LDAP server uses SSL'
    defaultto true
  end

  # Add autorequire
  autorequire(:ldap_entry) do
    # Strip off the first dn to autorequire the parent
    parent = self[:name].split(",").drop(1).join(",")
    parent
  end
  # The server has to run before we can add entries to the database
  autorequire(:service) { 'ldap-server' }

end
