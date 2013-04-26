module YammerRateLimited
  RATE_LIMIT_RETRIES = 50

  def error(job, exception)
    if ExceptionSilencer.is_rate_limit?(exception)
      @rate_limited = true
    else
      @rate_limited = false
      Airbrake.notify(exception)
    end
  end

  def failure(job)
    Airbrake.notify(error_message: "Job failure: #{job.last_error}")
  end

  def reschedule_at(attempts, time)
    if @rate_limited
      30.seconds.from_now
    end
  end

  def max_attempts
    @rate_limited ? RATE_LIMIT_RETRIES : Delayed::Worker.max_attempts
  end
end
