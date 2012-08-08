class Vote < ActiveRecord::Base
  attr_accessible :suggestion_id

  belongs_to :suggestion
  belongs_to :votable, polymorphic: true, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :votable_id, presence: true

  after_create :send_confirmation_email
  after_create :create_yammer_activity_for_new_vote

  def self.none
    where( id: nil)
  end

  def event
    suggestion.event
  end

  def user
    votable.user
  end

  private

  def create_yammer_activity_for_new_vote
    user.create_yammer_activity('update', event)
  end

  def send_confirmation_email
    UserMailer.delay.vote_confirmation(self)
  end
end
