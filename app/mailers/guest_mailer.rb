class GuestMailer < ActionMailer::Base
  def invitation(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email,
         from: "invitation@sched.do",
         subject: "#{@event.user.name} invited you to vote on '#{@event.name}'")
  end

  class Preview < MailView
    def invitation
      guest = Guest.first
      event = Event.first
      GuestMailer.invitation(guest, event)
    end
  end
end
