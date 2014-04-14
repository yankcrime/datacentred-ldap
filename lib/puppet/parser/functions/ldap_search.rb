require 'ldap_helper'
require 'net/ldap'

module Puppet::Parser::Functions
  newfunction(:ldap_search, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Search for an entry in an LDAP directory.

      Example:

        # Search in the example.net base for a mail with 'a*.com' matching.
        ldap_search([host, port, admin_user, admin_password, 
                   {:base => 'dc=example, dc=net', :filter => ['mail', 'a*.com'],
                   :attributes => ["mail", "cn", "sn", "objectclass"]}])

    ENDHEREDOC

    extend LDAPHelper
    ldap = ldap(args)
    ldap.search(params(args).merge(:filter => Net::LDAP::Filter.eq(*params(args)[:filter])),
                                   :return_result => false)
    return_code_and_message(ldap)
  end
end