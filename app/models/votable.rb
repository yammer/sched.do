module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :suggestion, dependent: :destroy

    validates :description, presence: { message: 'This field is required' }
  end

  def vote_count
    votes.count
  end
end
