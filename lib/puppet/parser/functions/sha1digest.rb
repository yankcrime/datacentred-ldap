require 'ldap_helper'

module Puppet::Parser::Functions
  newfunction(:sha1digest, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Hash a plaintext using SHA-1 Digest

      Example:

        sha1digest(["hello"]) # => "6d3L1UCJtULYvBnp47aqAvjtfM8="

    ENDHEREDOC

    [Digest::SHA1.digest(args[0])].pack('m0').strip
  end
end
