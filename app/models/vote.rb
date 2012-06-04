class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion

  def event
    suggestion.event
  end
end
