class UserMailer < ActionMailer::Base
  def vote_confirmation(vote)
    @user = vote.votable.user
    @event = vote.suggestion.event
    mail(to: @user.email,
         from: "votes@sched.do",
         subject: "You have voted for a Sched.do event!",
         template_path: "guest_mailer"
        )
  end
  
  class Preview < MailView
    def vote_confirmation
      vote = Vote.first
      UserMailer.vote_confirmation(vote)
    end
  end
end
