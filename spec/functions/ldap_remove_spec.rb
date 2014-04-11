require 'spec_helper'

describe "ldap_remove function" do
  include LDAPSetup

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  before(:each) do
    ldap_setup
    @ldap_entry = {:dn => 'uid=testy_test,ou=People,dc=datacentred,dc=co,dc=uk'}
    @params = @server_details.push(@ldap_entry)
  end

  it "should return a code and message" do
    @mock_ldap.expects(:remove).with(@ldap_entry)
    code, message = scope.function_ldap_remove(@params)
    code.should == 0
    message.should == "success"
  end
end