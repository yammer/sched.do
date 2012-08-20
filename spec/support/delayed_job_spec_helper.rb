module DelayedJobSpecHelper
  def work_off_delayed_jobs
    Delayed::Job.all.each do |job|
      job.payload_object.perform
      job.destroy
    end
  end
end
