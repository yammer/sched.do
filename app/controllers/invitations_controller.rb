class InvitationsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :create
  before_filter :require_guest_or_yammer_login, only: :create

  layout 'events'

  def create
    @invitation = Invitation.new(invitation_params_with_current_user)

    @event = @invitation.event

    if !@invitation.save
      flash[:error] = @invitation.errors.full_messages.last
    end

    redirect_to @event
  end

  private

  def invitation_params_with_current_user
    params[:invitation].merge(
      sender_id: current_user.id,
      sender_type: current_user.class.name
    )
  end
end
