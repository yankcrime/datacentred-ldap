require_relative '../../../ldap_helper'

module Puppet::Parser::Functions
  newfunction(:sha1digest, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Hash a plaintext using SHA-1 Digest

      Example:

        sha1digest(["hello"]) # => "{SHA}6d3L1UCJtULYvBnp47aqAvjtfM8="

    ENDHEREDOC

    "{SHA}#{Digest::SHA1.base64digest(args[0])}"
  end
end