require 'digest/sha1'

class Encrypter
  def initialize(string, salt)
    @string = string
    @salt = salt
  end

  def encrypt
    Digest::SHA1.hexdigest(salted_string)
  end

  private

  def salted_string
    "--#{@salt}--#{@string}--"
  end
end
