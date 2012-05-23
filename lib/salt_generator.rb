class SaltGenerator
  def generate
    SecureRandom.hex(64)
  end
end
