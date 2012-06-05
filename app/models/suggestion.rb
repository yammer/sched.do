class Suggestion < ActiveRecord::Base
  validates :description, presence: true

  attr_accessible :description

  belongs_to :event
end
