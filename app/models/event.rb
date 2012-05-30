class Event < ActiveRecord::Base
  attr_accessible :name, :suggestion, :suggestions_attributes

  has_many :suggestions

  validates :name, presence: true

  accepts_nested_attributes_for :suggestions
end
