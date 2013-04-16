class UsersController < ApplicationController
  layout 'events'

  def show
    @events = Event.joins(:invitations).
      where(
        'invitations.invitee_id = ? AND invitations.invitee_type = ?',
        current_user.id, current_user.class.name
      ).order('created_at DESC')
  end
end

