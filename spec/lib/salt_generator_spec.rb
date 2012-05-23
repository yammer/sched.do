require 'spec_helper'

describe SaltGenerator, '#generate' do
  it 'returns a 64-bit hex code' do
    SaltGenerator.new.generate.should =~ /^[0-9a-f]{128}$/
  end
end
