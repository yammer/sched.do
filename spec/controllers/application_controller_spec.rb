require 'spec_helper'

describe ApplicationController, '#current_user=' do
  it { should hide_action(:current_user=) }
end
