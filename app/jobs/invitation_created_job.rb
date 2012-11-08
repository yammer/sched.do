class InvitationCreatedJob < Struct.new(:invitation_id)
  PRIORITY = 1

  def self.enqueue(invitation)
    Delayed::Job.enqueue new(invitation.id), priority: PRIORITY
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    configure_yammer
    invitation.deliver_invitation
  end

  private

  def invitation
    Invitation.find(invitation_id)
  end

  def configure_yammer
    Yam.configure do |config|
      config.oauth_token = invitation.sender.access_token
      config.endpoint = invitation.sender.yammer_endpoint + "/api/v1"
    end
  end
end
