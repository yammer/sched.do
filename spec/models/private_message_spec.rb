require 'spec_helper'

describe(PrivateMessage, '#body') do
  it 'renders the erb template at the path it is instantiated with' do
    File.expects(:read).with('app/private_messages/dummy file path').returns('<%= @test_ivar %>')
    @test_ivar = 'test string'
    PrivateMessage.new('dummy file path', binding).body.should == 'test string'
  end
end
