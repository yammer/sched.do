class Invitation < ActiveRecord::Base
  attr_accessible :event_id, :name, :yammer_user_id

  attr_writer :yammer_user_id

  belongs_to :event
  belongs_to :user

  validates :event_id, presence: true
  validates :name, presence: true

  before_save :set_user_by_yammer_user_id

  def yammer_user_id
    user.try(:yammer_user_id) || @yammer_user_id
  end

  private

  def set_user_by_yammer_user_id
    user = User.find_by_yammer_user_id(yammer_user_id.to_s)
    if user
      self.user = user
    end
  end
end
