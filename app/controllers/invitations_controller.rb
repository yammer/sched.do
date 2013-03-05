class InvitationsController < ApplicationController
  skip_before_filter :require_yammer_login, only: :create
  before_filter :require_guest_or_yammer_login, only: :create

  layout 'events'

  def create
    check_for_empty_invitation_text
    redirect_to event
  end

  private

  def create_invitations(event, invitation_text)
    invitee_emails.each do |email|
      invitation = Invitation.new(
        event: event,
        invitation_text: invitation_text,
        invitee: find_or_create_user(email),
        sender: current_user
      )
      invitation.invite

      if invitation.invalid?
        flash[:error] = invitation.errors.full_messages.join(', ')
        break
      end
    end
  end

  def check_for_empty_invitation_text
    if invitation_text.empty?
      flash[:error] = 'Invitation text cannot be blank'
    else
      create_invitations(event, invitation_text)
    end
  end

  def event
    @event ||= Event.find(params[:invitation][:event_id])
  end

  def find_or_create_user(email)
    InviteeBuilder.new(email.strip, event).find_user_by_email_or_create_guest
  end

  def invitation_text
    if params[:invitation][:invitation_text]
      params[:invitation][:invitation_text].strip
    else
      ""
    end
  end

  def invitee_emails
    params[:invitation][:invitee_attributes][:name_or_email].split(',')
  end
end
