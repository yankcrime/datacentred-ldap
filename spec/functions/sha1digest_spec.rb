require 'spec_helper'

describe "sha-1 digest function" do

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  before(:each) do
    @password = 'secret'
  end

  it "turn a plaintext password into a hex digest with SHA-1" do
    scope.function_sha1digest([@password]).should == "{SHA}5en6G6MezRroT3XKqkdPOmY/BfQ="
  end
end
