class EventDecorator < Draper::Decorator
  delegate_all

  def build_suggestions
    primary_suggestions[0] ||= PrimarySuggestion.new
    primary_suggestions[1] ||= PrimarySuggestion.new
    primary_suggestions[0].secondary_suggestions[0] ||= SecondarySuggestion.new
    primary_suggestions[1].secondary_suggestions[0] ||= SecondarySuggestion.new
  end

  def first_invitee_for_invitation
    if invitees?
      first_invitee_name_with_commas
    else
      ' '
    end
  end

  def invitation_for(user)
    Invitation.where(
      event_id: self,
      invitee_id: user,
      invitee_type: user.class.name
    ).first
  end

  def invitees_with_current_user_first
    invitees.unshift(current_user).uniq
  end

  def other_invitees_who_have_not_voted_count
    other_invitees_who_have_not_voted.count
  end

  def user_not_invited?(user)
    invitees.exclude?(user)
  end

  def user_owner?(user)
    self.owner == user
  end

  def user_voted?(user)
    user_votes(user).exists?
  end

  def user_votes(user)
    user.votes.where(event_id: self)
  end

  private

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
