class YammerGroupInvitationsController < ApplicationController
  def create
    invitation = Invitation.new(
      event_id: event_id,
      invitee: invitee,
      sender: current_user
    )

    if !invitation.save
      flash[:error] = invitation.errors.full_messages.last
    end

    redirect_to invitation.event
  end

  private

  def invitee
    Group.find_or_create_by_yammer_group_id(
      yammer_group_id: yammer_group_id_param,
      name: name
    )
  end

  def yammer_group_id_param
    params[:invitation][:invitee_attributes][:yammer_group_id]
  end

  def event_id
    params[:invitation][:event_id]
  end

  def name
    params[:invitation][:invitee_attributes][:name_or_email]
  end
end
