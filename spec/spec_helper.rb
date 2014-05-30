require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'net/ldap'
require 'unit/support/ldap_setup'

RSpec.configure do |c|
  # Readable test descriptions
  c.color     = true
  c.formatter = :documentation

  # Enable mocking
  c.mock_with :rspec do |mock|
    mock.syntax = [:expect, :should]
  end

  # Ensure that we don't accidentally cache facts and environment
  c.before :each do
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
  end
end
