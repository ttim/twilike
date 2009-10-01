class CreateAddedTweets < ActiveRecord::Migration
  def self.up
    create_table :added_tweets do |t|
      t.string :tweet_id, :limit => 14
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :added_tweets
  end
end
