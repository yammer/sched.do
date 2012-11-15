class InvitationsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :create
  before_filter :require_guest_or_yammer_login, only: :create

  layout 'events'

  def create
    event = Event.find(params[:invitation][:event_id])
    create_invitations(event)
    redirect_to event
  end

  private

  def create_invitations(event)
    invitee_emails.each do |email|
      invitation = Invitation.new(
        event: event,
        invitee: InviteeBuilder.new(email.strip, event).find_user_by_email_or_create_guest,
        sender: current_user
      )

      if !invitation.save
        flash[:error] = invitation.errors.full_messages.last
        break
      end
    end
  end

  def invitee_emails
    params[:invitation][:invitee_attributes][:name_or_email].split(',')
  end
end
