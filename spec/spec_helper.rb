require 'puppetlabs_spec_helper/module_spec_helper'
require 'net/ldap'
require 'unit/support/ldap_setup'

RSpec.configure do |c|
  c.mock_with :rspec do |mock|
    mock.syntax = [:expect, :should]
  end
  c.include PuppetlabsSpec::Files

  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
  end

  c.after :each do
    PuppetlabsSpec::Files.cleanup
  end
end
