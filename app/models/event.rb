class Event < ActiveRecord::Base
  attr_accessible :name, :suggestion, :suggestions_attributes

  has_many :suggestions
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :suggestions, reject_if: :all_blank,
                                              allow_destroy: true
end
