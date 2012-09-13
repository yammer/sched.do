class EventDecorator < Draper::Base
  decorates :event

  def invitees_with_current_user_first
    invitees_with_creator.unshift(current_user).uniq
  end

  def first_invitee_for_invitation
    if invitees?
      first_invitee_name_with_commas
    else
      ' '
    end
  end

  private

  def current_user
    h.current_user
  end

  def first_invitee_with_name
    invitees.find { |i| i.name.present? }
  end

  def first_invitee_name_with_commas
    if first_invitee_with_name
      ", #{first_invitee_with_name.name}, "
    else
      ' '
    end
  end

  def invitees?
    invitees.count > 0
  end
end
