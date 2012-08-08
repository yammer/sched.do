class UserMailer < ActionMailer::Base
  default from: '"Sched.do" <app@sched.do>'

  def vote_confirmation(vote)
    @user = vote.votable.user
    @event = vote.suggestion.event
    mail(to: @user.email,
      subject: "#{@user.name}, thanks for voting with Sched.do")
  end

  def invitation(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email,
      from: "\"#{event.user.name} via Sched.do \" <app@sched.do>",
      subject: "You have been invited to a Sched.do event!")
  end


  class Preview < MailView
    def vote_confirmation
      vote = Vote.first
      @user = vote.votable.user
      @event = vote.suggestion.event
      UserMailer.vote_confirmation(vote)
    end

    def invitation
      guest = Guest.first
      event = Event.first
      UserMailer.invitation(guest, event)
    end
  end
end
