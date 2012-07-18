class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :votable, polymorphic: true, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :votable_id, presence: true

  after_create :send_confirmation_email

  def event
    suggestion.event
  end

  private

  def send_confirmation_email
    UserMailer.vote_confirmation(self).deliver
  end
end
