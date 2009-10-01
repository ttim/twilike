class AddedTweet < ActiveRecord::Base
  JOB_PRIORITY = 2
  JOB_DELAY = 20.minute
  
  validates_presence_of :tweet_id, :message => "tweet id is required!"
  validates_uniqueness_of :tweet_id, :message => "tweet id is unique!"

  before_create :perform

  def perform
    result = TweetParser.parse(self.data["text"]) # result = { :name => "", :rating => 0|+1|-1, :text => "" }
    
    if result
      tmp = Omdb.movie_by_name(result[:name])
      
      if tmp["result"] == "ok"
        movie = Movie.find_or_create_by_imdb_id(tmp["movie"]["imdb_id"])
        user = User.find_or_create_by_twitter_id(self.data["user"]["id"])

        Opinion.create!(:tweet_id => self.data["id"], :movie => movie, :user => user, :text => result[:text], :rating => result[:rating], :created_at => self.data["created_at"])
      else
        if tmp["result"] != "deleted"
          Omdb.add_name_to_moderate(result[:name])
          
          unless (Delayed::Job.enqueue(self, JOB_PRIORITY, Time.now+JOB_DELAY))
            raise "add new job not successful"
          end
        end
      end
    end

    true
  end
end
