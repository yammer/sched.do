if Rails.env.development? || Rails.env.test?
  class Preview < MailView
    def event_created_confirmation(event)
      event = Event.first
      UserMailer.event_created_confirmation(event)
    end

    def invitation
      invitation = Invitation.first
      UserMailer.invitation(invitation)
    end

    def vote_confirmation
      vote = Vote.first
      user = vote.voter
      event = vote.suggestion.event
      UserMailer.vote_confirmation(vote)
    end
  end
end
