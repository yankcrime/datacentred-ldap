require 'spec_helper'

describe "domain2dn function" do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  before(:each) do
    @domain = 'test.domain'
  end

  it "turn a dotted domain into a DN style string" do
    scope.function_domain2dn([@domain]).should == "dc=test,dc=domain"
  end
end
