class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :user

  validates :suggestion_id, uniqueness:  { scope: :user_id },
    presence: true

  validates :user_id, presence: true

  def event
    suggestion.event
  end
end
