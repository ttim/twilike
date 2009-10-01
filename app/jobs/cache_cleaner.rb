class CacheCleaner
  JOB_PRIORITY = 5
  JOB_DELAY = 1.minute

  def perform
    Cache.clean

    # re-add a job
    unless (Delayed::Job.enqueue(self, JOB_PRIORITY, Time.now+JOB_DELAY))
      raise "add new job not successful"
    end
  end
end