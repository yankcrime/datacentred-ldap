require 'spec_helper'

describe "ldap_search function" do
  include LDAPSetup

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  before(:each) do
    ldap_setup
    @ldap_entry = {:base => 'dc=datacentred,dc=co,dc=uk', :filter => ['mail', 'a*.com'],
                   :attributes => ["mail", "cn", "sn", "objectclass"]}
    @params = @server_details.push(@ldap_entry)
  end

  [true, false].each do |bool|
    it "should react to success" do
      @mock_ldap.expects(:search).with(@ldap_entry.merge(filter: Net::LDAP::Filter.eq(*@ldap_entry[:filter])),
                                         return_result: false).returns(bool)
      code, message = scope.function_ldap_search(@params)
      code.should == 0
      message.should == "success"
    end
  end
end
