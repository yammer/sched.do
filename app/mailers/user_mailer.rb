class UserMailer < ActionMailer::Base
  def vote_confirmation(vote)
    @user = vote.votable.user
    @event = vote.suggestion.event
    mail(to: @user.email,
         from: "votes@sched.do",
         subject: "#{@user.name}, thanks for voting with Sched.do",
         template_path: "guest_mailer"
        )
  end

  class Preview < MailView
    def vote_confirmation
      vote = Vote.first
      @user = vote.votable.user
      @event = vote.suggestion.event
      UserMailer.vote_confirmation(vote)
    end
  end
end
