require_relative '../../../ldap_helper'
require 'net/ldap'

module Puppet::Parser::Functions
  newfunction(:ldap_modify, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Modify an entry in an LDAP directory.

      Example:

        # Add a mail for user with UID 'testy_test', set sn to blank, change givenName.
        ldap_modify([host, port, admin_user, admin_password, 
                    {:dn => 'uid=testy_test,ou=People,dc=example,dc=net',
                    :operations => [
                      [:add, :mail, "aliasaddress@example.com"],
                      [:replace, :givenName, 'George'],
                      [:delete, :sn]
                    ]}])

    ENDHEREDOC

    extend LDAPHelper
    ldap = ldap(args)
    ldap.modify(params(args))
    return_code_and_message(ldap)
  end
end