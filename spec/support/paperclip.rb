module Paperclip
  class << self
    def run(*args)
      '100x100'
    end
  end
end

class Paperclip::Attachment
  def post_process
  end
end
