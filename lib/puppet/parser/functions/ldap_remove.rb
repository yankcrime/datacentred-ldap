require 'ldap_helper'
require 'net/ldap'

module Puppet::Parser::Functions
  newfunction(:ldap_remove, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Remove an entry in an LDAP directory.

      Example:

        # Remove entry for UID 'testy_test'.
        ldap_remove([host, port, admin_user, admin_password,
          {:dn => 'uid=testy_test,ou=People,dc=example,dc=net'}])

    ENDHEREDOC

    extend LDAPHelper
    ldap = ldap(args)
    ldap.remove(params(args))
    return_code_and_message(ldap)
  end
end