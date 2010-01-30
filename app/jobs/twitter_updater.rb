class TwitterUpdater
  JOB_PRIORITY = 7
  JOB_DELAY = 3.minute

  def add_tweet_by_id(id)
    if (AddedTweet.find_by_tweet_id(id.to_s) == nil)
      tweet = Twitter.status(id)

      # update user info
      user = User.find_by_twitter_id(tweet["user"]["id"])
      
      if user != nil 
        user.update_info(tweet["user"]) 
        user.save!
      end

      raise "not successful tweet adding" unless AddedTweet.create(:tweet_id => id)
    end
  end

  def perform
    tweets = Twitter.last_tweets

    tweets["results"].reverse.each do |tmp|
      begin
        add_tweet_by_id(tmp["id"])
      rescue
      end 
    end
    
    # readd a job
    unless (Delayed::Job.enqueue(self, JOB_PRIORITY, Time.now+JOB_DELAY))
      raise "add new job not successful"
    end
  end
end