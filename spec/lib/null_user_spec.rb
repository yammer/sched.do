require 'spec_helper'

describe NullUser do
  it { expect(subject).to be_blank }
  it { expect(subject).to_not be_present }
  it { expect(subject).to_not be_yammer_user }
end
