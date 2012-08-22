module EventsHelper
  def display_invitee_in_grid?(event, invitee)
    current_user == invitee || 
    event.user_owner?(current_user) ||
    event.user_voted?(invitee)
  end
end
