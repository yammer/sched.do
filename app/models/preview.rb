if Rails.env.development? || Rails.env.test?
  class Preview < MailView
    def event_created_confirmation(event)
      UserMailer.event_created_confirmation(event)
    end

    def invitation
      invitation = Invitation.last
      event = invitation.event
      UserMailer.invitation(event.owner, invitation)
    end

    def vote_confirmation
      vote = Vote.first
      user = vote.voter
      event = vote.suggestion.event
      UserMailer.vote_confirmation(vote)
    end
  end
end
