class TweetParser
  def self.parse(tweet)
    # result = { :name => "", :rating => 0|+1|-1, :text => "" }
    tweet += ""
    
    # rating parse
    current_rating = -1
    rating = nil

    ["-", "=", "+"].each do |rate|
      index = tweet.index("#twilike"+rate)

      if index != nil
        rating = current_rating
        tweet[index..index+8] = ""
      end

      current_rating += 1
    end

    return nil if rating == nil

    # movie parse
    index = tweet.index(".")
    if index != nil
      movie = tweet[0..index-1]
      tweet[0..index] = ""
    else
      movie = tweet
      tweet = ""
    end

    { :name => movie, :rating => rating, :text => tweet.strip }
  end
end