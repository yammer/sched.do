module EventHelper
  def build_suggestions(event)
    event.primary_suggestions[0] ||= PrimarySuggestion.new
    event.primary_suggestions[1] ||= PrimarySuggestion.new
    event.primary_suggestions[0].secondary_suggestions[0] ||= SecondarySuggestion.new
    event.primary_suggestions[1].secondary_suggestions[0] ||= SecondarySuggestion.new
  end

  def first_invitee_for_invitation(event)
    if invitees?(event)
      first_invitee_name_with_commas(event)
    else
      ' '
    end
  end

  def invitation_for(event, user)
    Invitation.where(
      event_id: event,
      invitee_id: user,
      invitee_type: user.class.name
    ).first
  end

  def invitees_with_current_user_first(event, user)
    event.invitees.unshift(user).uniq
  end

  def other_invitees_who_have_not_voted_count(event, user)
    other_invitees_who_have_not_voted(event, user).count
  end

  def user_not_invited?(event, user)
    event.invitees.exclude?(user)
  end

  def user_owner?(event, user)
    event.owner == user
  end

  def user_voted?(event, user)
    user_votes(event, user).exists?
  end

  def user_votes(event, user)
    user.votes.where(event_id: event)
  end

  def other_invitees_who_have_not_voted(event, user)
    invitees_who_have_not_voted(event).reject do |invitee|
      invitee == user
    end
  end

  def invitees_who_have_not_voted(event)
    event.invitees.select { |invitee| not invitee.voted_for_event?(event) } end

  def invitees?(event)
    event.invitees.count > 0
  end

  def first_invitee_name_with_commas(event)
    if first_invitee_with_a_name(event)
      ", #{first_invitee_with_a_name(event).name}, "
    else
      ' '
    end
  end

  def first_invitee_with_a_name(event)
    event.invitees.find { |i| i.name.present? }
  end
end
