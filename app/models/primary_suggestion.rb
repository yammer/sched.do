# Generally used to represent a date

class PrimarySuggestion < ActiveRecord::Base
  attr_accessible :description, :secondary_suggestions_attributes

  validates :description, presence: { message: 'This field is required' }

  belongs_to :event
  has_many :secondary_suggestions, order: 'created_at'
  has_many :votes, as: :suggestion, dependent: :destroy

  accepts_nested_attributes_for :secondary_suggestions, 
    reject_if: :all_blank,
    allow_destroy: true

  def vote_count
    votes.count
  end

  def full_description
    description
  end
end
