require 'ldap_helper'
require 'net/ldap'

module Puppet::Parser::Functions
  newfunction(:ldap_add, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Add an entry to an LDAP directory.

      Example:

        # Add an entry for the user with UID 'testy_test'.
        ldap_add([host, port, admin_user, admin_password,
                   {:dn => 'uid=testy_test,ou=People,dc=example,dc=net',
                   :attributes => {
                     :cn => 'Testy Tester', :givenName => 'Testy',
                     :objectClass => ['top', 'person', 'inetorgPerson'],
                     :sn => 'Tester', :mail => 'testy@test.com', 
                     :uid => 'testy_test',
                     :userPassword => '{SHA}6d3L1UCJtULYvBnp47aqAvjtfM8='}}])

    Note: User passwords should be hashed with SHA1 as in the example.

    ENDHEREDOC

    extend LDAPHelper
    ldap = ldap(args)
    ldap.add(params(args))
    return_code_and_message(ldap)
  end
end
