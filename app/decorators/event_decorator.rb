class EventDecorator < Draper::Base
  decorates :event

  def invitees_with_current_user_first
    invitees_with_creator.unshift(current_user).uniq
  end

 private

  def current_user
    h.current_user
  end
end
