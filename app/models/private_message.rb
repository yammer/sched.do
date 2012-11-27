class PrivateMessage
  PRIVATE_MESSAGES_PATH = 'app/private_messages'

  def initialize(template_path, binding)
    @template_path = template_path
    @binding = binding
  end

  def body
   method_body
  end

  private

  def method_body
    ERB.new(File.read("#{PRIVATE_MESSAGES_PATH}/#{@template_path}")).result(@binding)
  end
end
