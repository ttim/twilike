class AddIndexesForAddedTweets < ActiveRecord::Migration
  def self.up
    add_index :added_tweets, :tweet_id
  end

  def self.down
    remove_index :added_tweets, :tweet_id
  end
end
