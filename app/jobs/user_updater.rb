class UserUpdater
  JOB_KOEF = 0.7
  JOB_PRIORITY = 1
  JOB_MIN_DAYS = 3.day
  JOB_MAX_DAYS = 30.day

  def initialize(user_id)
    @user_id = user_id
  end

  def perform
    user = User.find(@user_id)

    user.update_info(Twitter.user_info(user.twitter_id))
    user.save!
    
    # calc time to add
    delta = (Time.now - user.created_at) * JOB_KOEF
    delta = JOB_MAX_DAYS if delta > JOB_MAX_DAYS
    delta = JOB_MIN_DAYS if delta < JOB_MIN_DAYS
    
    unless (Delayed::Job.enqueue(self, JOB_PRIORITY, Time.now+delta))
      raise "add new job not successful"
    end

    true
  end

end