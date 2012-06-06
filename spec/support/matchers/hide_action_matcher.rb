RSpec::Matchers.define :hide_action do |action|
  match do |controller|
    ! controller.action_methods.include?(action.to_s) &&
      controller.hidden_actions.include?(action.to_s)
  end
end
