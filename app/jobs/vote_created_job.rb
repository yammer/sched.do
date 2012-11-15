class VoteCreatedJob < Struct.new(:vote_id)
  PRIORITY = 1
  ACTION = 'vote'

  def self.enqueue(vote)
    Delayed::Job.enqueue(new(vote.id), priority: PRIORITY)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  def perform
    configure_yammer
    voter.create_yammer_activity(ACTION, event)
    VoteConfirmationEmailJob.enqueue(vote)
  end

  private

  def event
    vote.event
  end

  def no_recent_votes
    voter.
      votes.
      where(['id != ?', vote.id]).
      where(['created_at > ?', VOTE_EMAIL_DELAY.ago]).
      where(['created_at < ?', vote.created_at]).
      empty?
  end

  def vote
    Vote.find(vote_id)
  end

  def voter
    vote.voter
  end

  def configure_yammer
    Yam.configure do |config|
      if voter.yammer_user?
        config.oauth_token = voter.access_token

        if voter.yammer_staging
          config.endpoint = YAMMER_STAGING_ENDPOINT
        end
      end
    end
  end
end
