class InvitationsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :create
  before_filter :require_guest_or_yammer_login, only: :create

  layout 'events'

  def create
    @invitation = Invitation.new(params[:invitation])
    @event =  @invitation.event

    if !@invitation.save
      flash[:error] = @invitation.errors.full_messages.last
    end

    redirect_to @event
  end
end
