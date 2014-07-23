module Puppet::Parser::Functions
  newfunction(:domain2dn, :type => :rvalue, :doc => <<-EOS
Converts a DNS style domain string into a string suitable for use as a LDAP DN
by constructing 'dc=' elements for each domain component.

*Example:*

foo.example.org

Would become:

dc=foo,dc=example,dc=org

EOS
  ) do |args|
    if (args.size != 1) then
      raise(Puppet::ParseError, "port389_domain2dn(): Wrong number of arguments "+
        "given #{args.size} for 1")
    end
    
    args[0].split('.').map{ |x| "dc=" + x }.join(',')
  end
end
