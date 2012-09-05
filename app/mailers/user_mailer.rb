class UserMailer < ActionMailer::Base
  default from: %{"Sched.do" <no-reply@sched.do>}

  def event_created_confirmation(event)
    @event = event
    @creator = @event.user
    mail(to: @creator.email,
      from: %{'Sched.do' <no-reply@sched.do>},
      subject: "You created #{@event.name} on Sched.do")
  end

  def invitation(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email,
      from: %{"#{@event.user.name} via Sched.do" <no-reply@sched.do>},
      subject: "You have been invited to a Sched.do event!")
  end

  def vote_confirmation(vote)
    @user = vote.voter
    @event = vote.suggestion.event
    mail(to: @user.email,
      subject: "#{@user.name}, thanks for voting with Sched.do")
  end

  class Preview < MailView
    def event_created_confirmation(event)
      event = Event.first
      UserMailer.event_created_confirmation(event)
    end

    def invitation
      guest = Guest.first
      event = Event.first
      UserMailer.invitation(guest, event)
    end

    def vote_confirmation
      vote = Vote.first
      @user = vote.voter
      @event = vote.suggestion.event
      UserMailer.vote_confirmation(vote)
    end
  end
end
