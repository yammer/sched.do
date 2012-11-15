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

  def sender
    invitation.sender
  end

  def configure_yammer
    Yam.configure do |config|
      if sender.yammer_user?
        config.oauth_token = sender.access_token

        if sender.yammer_staging
          config.endpoint = YAMMER_STAGING_ENDPOINT
        end
      end
    end
  end
end
