class EventDecorator < Draper::Base
  decorates :event

  def invitees_with_current_user_first
    invitees_with_creator.unshift(current_user).uniq
  end

  def first_invitee_for_invitation
    if invitees.count > 0
      ", #{invitees.first.name}, "
    else
      ' '
    end
  end

 private

  def current_user
    h.current_user
  end
end
