class GuestMailer < ActionMailer::Base
  def invitation(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email,
         from: "invitation@sched.do",
         subject: "You have been invited to a Sched.do event!")
  end

  def vote_confirmation(guest_vote)
    @guest = guest_vote.guest
    @event = guest_vote.vote.suggestion.event
    mail(to: @guest.email,
         from: "votes@sched.do",
         subject: "You have voted for a Sched.do event!")
  end

  class Preview < MailView
    def invitation
      guest = Guest.first
      event = Event.first
      GuestMailer.invitation(guest, event)
    end

    def vote_confirmation
      guest_vote = GuestVote.first
      GuestMailer.vote_confirmation(guest_vote)
    end
  end
end
