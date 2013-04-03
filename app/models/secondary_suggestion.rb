# Generally used to represent a time

class SecondarySuggestion < ActiveRecord::Base
  validates :description, presence: { message: 'This field is required' }

  belongs_to :primary_suggestion
  has_many :votes, as: :suggestion, dependent: :destroy

  def vote_count
    votes.count
  end

  def event
    primary_suggestion.event
  end

  def full_description
    "#{primary_suggestion.try(:description)} #{description}".strip
  end
end
