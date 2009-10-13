class Opinion < ActiveRecord::Base
  LAST_COUNT = 5
  
  belongs_to :movie
  belongs_to :user

  validates_presence_of :tweet_id, :message => "tweet id is required!"
  validates_uniqueness_of :tweet_id, :message => "tweet id is unique!"

  default_scope :order => 'created_at DESC' 

  after_create :remove_old_opinions, :enqueue_translate_job

  def remove_old_opinions
    Opinion.delete_all(["user_id = :user_id AND movie_id = :movie_id AND id != :id",
                        {:user_id => self.user, :movie_id => self.movie, :id => self.id }])
  end

  def enqueue_translate_job
    Delayed::Job.enqueue(OpinionTranslate.new(self), OpinionTranslate::JOB_PRIORITY, Time.now)
  end

  def self.last
    self.all(:limit => LAST_COUNT)
  end

  def translated_text
    return self.text if I18n.locale.to_s == "ru"

    translated = super

    return translated if translated != nil

    self.text
  end

  def twitter_url
    "http://twitter.com/"+self.user.screen_name+"/status/"+self.tweet_id
  end
end