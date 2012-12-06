class EventDecorator < Draper::Base
  decorates :event

  def other_invitees_count
    invitees.count - event_owner
  end

  def invitees_with_current_user_first
    invitees.unshift(current_user).uniq
  end

  def other_invitees_who_have_not_voted_count
    other_invitees_who_have_not_voted.count
  end

  def first_invitee_for_invitation
    if invitees?
      first_invitee_name_with_commas
    else
      ' '
    end
  end

  private

  def event_owner
    1
  end

  def current_user
    h.current_user
  end

  def other_invitees_who_have_not_voted
    invitees_who_have_not_voted.reject do |invitee|
      invitee == current_user
    end
  end

  def invitees_who_have_not_voted
    invitees.select { |invitee| not invitee.voted_for_event?(self) }
  end

  def invitees?
    invitees.count > 0
  end

  def first_invitee_name_with_commas
    if first_invitee_with_a_name
      ", #{first_invitee_with_a_name.name}, "
    else
      ' '
    end
  end

  def first_invitee_with_a_name
    invitees.find { |i| i.name.present? }
  end
end
