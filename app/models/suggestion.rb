class Suggestion < ActiveRecord::Base
  validates :time, presence: true
  validates_datetime :time, after: :now, after_message: "must be in the future"

  attr_accessible :time

  belongs_to :event
end
