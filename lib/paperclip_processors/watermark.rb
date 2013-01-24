module Paperclip
  class Watermark < Processor
    attr_accessor :basename, :file, :format, :watermark

    def initialize(file, options = {}, attachment = nil)
      @file = file
      @attachment = attachment

      @format = File.extname(file.path)
      @basename = File.basename(file.path, format)
      @watermark = attachment.instance.watermark
    end

    def make
      dst = Tempfile.new([basename, format].compact.join('.'))
      dst.binmode

      parameters = '-gravity southeast :watermark :source :dest'

      Paperclip.run(
        'composite',
        parameters,
        watermark: watermark,
        source: File.expand_path(file.path),
        dest: File.expand_path(dst.path)
      )

      dst
    end
  end
end
