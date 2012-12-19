require 'spec_helper'

describe NullUser do
  it { should be_blank }
  it { should_not be_present }
  it { should_not be_yammer_user }
end
