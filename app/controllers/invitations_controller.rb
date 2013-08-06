class InvitationsController < ApplicationController
  skip_before_filter :require_yammer_login, only: [:create, :destroy]
  before_filter :require_guest_or_yammer_login, only: [:create, :destroy]

  layout 'events'

  def create
    event_inviter = EventInviter.new(event_inviter_attributes)

    if event_inviter.valid?
      event_inviter.send_invitations
    else
      flash[:error] = event_inviter.invalid_invitation_errors
    end

    redirect_to event
  end

  def destroy
    invitation = Invitation.find(params[:id])

    if invitation.deletable_by?(current_user)
      invitation.destroy
      flash[:notice] = "Successfully removed from #{invitation.event.name}"
    end

    redirect_to after_destroy_path(invitation.event)
  end

  private

  def event_inviter_attributes
    {
      current_user: current_user,
      event:  event,
      invitee_emails: invitee_emails,
      invitation_text: invitation_text
    }
  end

  def event
    @event ||= Event.find(params[:invitation][:event_id])
  end

  def invitation_text
    params[:invitation][:invitation_text].strip
  end

  def invitee_emails
    params[:invitation][:invitee_attributes][:name_or_email].split(',')
  end

  def after_destroy_path(event)
    if event.owned_by?(current_user)
      event_path(event)
    elsif current_user.is_a?(User)
      polls_path
    else
      root_path
    end
  end
end
