class Twitter
  TWITTER_USERNAME = "twilike"
  TWITTER_PASSWORD = "14111989"
  
  include HTTParty

  base_uri 'http://twitter.com'
  basic_auth TWITTER_USERNAME, TWITTER_PASSWORD
  
  format :json

  def self.user_info(twitter_id)
    self.get('/users/show.json?user_id='+twitter_id.to_s)
  end

  def self.last_tweets
    # self.get('http://search.twitter.com/search.json?q=%23twilike&rpp=100')
    self.get('http://service.twilike.net/last_tweets.php')
  end

  def self.status(tweet_id)
    self.get('/statuses/show/'+tweet_id.to_s+'.json')
  end
end