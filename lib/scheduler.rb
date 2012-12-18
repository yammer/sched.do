module Scheduler
  def self.daily
    Invitation.deliver_automatic_reminders
  end
end
