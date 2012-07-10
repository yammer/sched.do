module ActivityFeedHelpers
  def create_activity_message(message)
    p message
  end
end

RSpec.configure do |c|
  c.include ActivityFeedHelpers
end
