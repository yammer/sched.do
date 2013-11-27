require 'spec_helper'
load "#{Rails.root}/lib/paperclip_processors/watermark.rb"

describe Paperclip::Watermark, '#new' do
  it 'sets format and basename based on the file passed in' do
    file = double(path: 'logo.png')
    user = build_stubbed(:user)
    attachment = double(instance: user)

    paperclip_watermark = Paperclip::Watermark.new(file, {}, attachment)

    expect(paperclip_watermark.format).to eq '.png'
    expect(paperclip_watermark.basename).to eq 'logo'
  end

  it 'assigns watermark to the watermark of the attachment passed in' do
    file = double(path: 'logo.png')
    watermark = double(watermark: 'watermark string')
    attachment = double(instance: watermark)

    paperclip_watermark = Paperclip::Watermark.new(file, {}, attachment)

    expect(paperclip_watermark.watermark).to eq 'watermark string'
  end
end

describe Paperclip::Watermark, '#make' do
  it 'returns a Tempfile' do
    file = double(path: 'logo.png')
    user = build_stubbed(:user)
    attachment = double(instance: user)

    paperclip_watermark = Paperclip::Watermark.new(file, {}, attachment).make

    expect(paperclip_watermark).to be_an_instance_of(Paperclip::Tempfile)
  end
end
