require 'spec_helper'

describe 'domain2dn' do

  before(:each) do
    @domain = 'test.domain'
  end

  it {
    is_expected.to run.with_params(@domain).and_return('dc=test,dc=domain')
  }

end
