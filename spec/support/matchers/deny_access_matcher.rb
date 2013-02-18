RSpec::Matchers.define :deny_access do
  include Rails.application.routes_url_helpers

  match do |controller|
    expect(response).to redirect_to(root_path)
  end

  description do
    'deny access'
  end

  failure_message_for_should do
    "expected #{described_class} to deny access"
  end

  failure_message_for_should_not do
    "did not expect #{described_class} to deny access"
  end
end
