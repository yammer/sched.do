class EventDecorator < Draper::Base
  decorates :event

  def other_invitees_count
    (invitees.count - 1).abs
  end

  def invitees_with_current_user_first
    invitees.unshift(current_user).uniq
  end

  def invitations_excluding_current_user
    invitations.reject { |invitation| invitation.invitee == current_user }
  end

  def other_invitees_who_have_not_voted_count
    (invitees_who_have_not_voted.length - 1).abs
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

  def invitees_who_have_not_voted
    invitees.select{ |invitee| not invitee.voted_for_event?(self) }
  end
end
