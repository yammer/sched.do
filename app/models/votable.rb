module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :suggestion, dependent: :destroy

    validates :description, presence: { message: 'This field is required' }
  end

  def vote_count
    votes.where(deleted_at: nil).count
  end
end
