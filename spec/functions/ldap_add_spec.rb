
require 'spec_helper'

describe "ldap_add function" do
  include LDAPSetup

	let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  before(:each) do
    ldap_setup
    @ldap_entry = {:dn => 'uid=testy_test,ou=People,dc=datacentred,dc=co,dc=uk',
                   :attributes => {
                     :cn => 'Testy Tester', :givenName => 'Testy',
                     :objectClass => ['top', 'person', 'inetorgPerson'],
                     :sn => 'Tester', :mail => 'testy@test.com', 
                     :uid => 'testy_test',
                     :userPassword => '{SHA}6d3L1UCJtULYvBnp47aqAvjtfM8='}}
    @params = @server_details.push(@ldap_entry)
  end

	it "should return a code and message" do
    @mock_ldap.expects(:add).with(@ldap_entry)
    code, message = scope.function_ldap_add(@params)
    code.should == 0
    message.should == "success"
	end
end
