require 'spec_helper'

class IvarContainer
  attr_reader :test_ivar

  def initialize
    @test_ivar = 'test string'
  end

  def get_binding
    binding
  end
end

describe PrivateMessageTemplate, '#body' do
  it 'renders the erb template using provided class binding' do
    File.stub(read: '<%= @test_ivar %>')
    ivar_container = IvarContainer.new

    rendered_erb = PrivateMessageTemplate.new('dummy file path', ivar_container.get_binding).body

    expect(rendered_erb).to eq ivar_container.test_ivar
  end

  it 'reads the file at the path provided' do
    File.stub(read: 'test erb')

    PrivateMessageTemplate.new('dummy file path', nil).body

    expect(File).to have_received(:read).with('app/private_messages/dummy file path')
  end
end
