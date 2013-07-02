module EventHelper
  def build_suggestions(event)
    event.primary_suggestions[0] ||= PrimarySuggestion.new
    event.primary_suggestions[1] ||= PrimarySuggestion.new
    event.primary_suggestions[0].secondary_suggestions[0] ||= SecondarySuggestion.new
    event.primary_suggestions[1].secondary_suggestions[0] ||= SecondarySuggestion.new
  end

  def closed_event_text(event)
    if event.closed?
      '(Closed)'
    end
  end

  def first_invitee_for_invitation(event)
    if invitees?(event)
      first_invitee_name_with_commas(event)
    else
      ' '
    end
  end

  def first_invitee_with_a_name(event)
    event.invitees.find { |invitee| invitee.name.present? }
  end

  def first_invitee_name_with_commas(event)
    if first_invitee_with_a_name(event)
      ", #{first_invitee_with_a_name(event).name}, "
    else
      ' '
    end
  end

  def invitation_for(event, user)
    user.invitations.where(event_id: event).first
  end

  def invitation_text_disabled?(event, user)
    !user_owner?(event, user)
  end

  def invitees?(event)
    event.invitees.count > 0
  end

  def invitees_who_have_not_voted(event)
    event.invitees.reject { |invitee| invitee.voted_for_event?(event) }
  end

  def invitees_with_current_user_first(event, user)
    event.invitees.unshift(user).uniq
  end

  def last_non_owner_invitation_text(event)
    default_text =
      t('events_show.default_custom_invitation_text', event_name: event.name)
    invitations = event.invitations
    non_owner_invitations =
      invitations.select do |invitation|
        invitation.invitee != event.owner
      end

    if non_owner_invitations != []
      non_owner_invitations.first.invitation_text
    else
      default_text
    end
  end

  def other_invitees_who_have_not_voted(event, user)
    invitees_who_have_not_voted(event).reject do |invitee|
      invitee == user
    end
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

  def reminder_link(text, event, options = {})
    if event.open?
      receiver = options.fetch(:receiver, event)
      path = reminders_path(
        reminder: {
          receiver_id: receiver.id,
          receiver_type: receiver.class.name
        },
        event_id: event.uuid
      )

      link_to(text, path, method: :post, class: options[:class])
    elsif options[:remind_all].nil?
      'Invitee did not vote'
    end
  end

  def table_cell_classes_for_user(invitee, event)
    if user_owner?(event, invitee)
      'current-user event-creator'
    elsif current_user == invitee
      'current-user'
    end
  end

  def votable_suggestions(event)
    event.suggestions.inject([]) do |result, suggestion|
      if suggestion.suggestions.any?
        result += suggestion.suggestions.map(&:full_description)
      else
        result << suggestion.full_description
      end

      result
    end
  end
end
