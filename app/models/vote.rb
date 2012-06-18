class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :votable, polymorphic: true, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :votable_id, presence: true

  def event
    suggestion.event
  end
end
