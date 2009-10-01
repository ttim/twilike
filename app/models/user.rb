class User < ActiveRecord::Base
  has_many :opinions

  validates_presence_of :twitter_id, :message => "twitter id is required!"
  validates_uniqueness_of :twitter_id, :message => "twitter id is unique!"

  after_create :add_info_and_user_job

  def add_info_and_user_job
    # 1) add info
    update_info(Twitter.user_info(self.twitter_id))
    self.save!
    # 2) add job
    Delayed::Job.enqueue(UserUpdater.new(self.id), UserUpdater::JOB_PRIORITY, Time.now+UserUpdater::JOB_MIN_DAYS)
    # TODO: if enqueue not successul ??? O_O
  end

  def update_info(info)    
    self.name = info["name"]
    self.screen_name = info["screen_name"]

    self.profile_image_url = info["profile_image_url"]
  end

  def self.top(count, time_interval = nil)
    if time_interval == nil
      condition = { }
    else
      condition = ["created_at > :min_created_at",
                   { :min_created_at => Time.now-time_interval}]
    end

    result = []

    Opinion.find(:all, :select => "user_id, count(id) as opinion_count, user_id as created_at",
                 :conditions => condition,
                 :group => "user_id",
                 :order => "opinion_count DESC",
                 :limit => count).each { |user| result << User.find(user.user_id) }

    result
  end

  def opinions_by_period(time_interval = nil)
    return Opinion.count(:conditions => {:user_id => self} ) if time_interval == nil

    Opinion.count(:conditions => ["user_id = :user_id AND created_at > :min_created_at",
                                  {:user_id => self, :min_created_at => Time.now-time_interval}])
  end

  def twitter_url
    "http://twitter.com/"+self.screen_name
  end

  def latest_opinion
    Opinion.first(:conditions => { :user_id => self})
  end

  def opinions_by_rating(rating, time_interval = nil)
    return Opinion.count(:conditions => {:user_id => self, :rating => rating} ) if time_interval == nil

    Opinion.count(:conditions => ["user_id = :user_id AND rating = :rating AND created_at > :min_created_at",
                                  {:user_id => self, :rating => rating, :min_created_at => Time.now-time_interval}])
  end

  def plus_count(time_interval = nil)
    opinions_by_rating(1, time_interval)
  end

  def neutral_count(time_interval = nil)
    opinions_by_rating(0, time_interval)
  end

  def minus_count(time_interval = nil)
    opinions_by_rating(-1, time_interval)
  end  
end