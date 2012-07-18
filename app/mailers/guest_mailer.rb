class GuestMailer < ActionMailer::Base
  def invitation(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email,
         from: "invitation@sched.do",
         subject: "You have been invited to a Sched.do event!")
  end

  class Preview < MailView
    def invitation
      guest = Guest.first
      event = Event.first
      GuestMailer.invitation(guest, event)
    end
  end
end
