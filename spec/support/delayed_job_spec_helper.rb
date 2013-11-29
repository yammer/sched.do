module DelayedJobSpecHelper
  def work_off_delayed_jobs
    Delayed::Job.all.each do |job|
      if job.run_at < Time.now
        job.payload_object.perform
        job.destroy
      end
    end
  end
end
