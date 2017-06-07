require 'spec_helper'

describe 'sha1digest' do

  before(:each) do
    @password = 'secret'
  end

  it {
    is_expected.to run.with_params(@password).and_return('{SHA}5en6G6MezRroT3XKqkdPOmY/BfQ=')
  }

end
