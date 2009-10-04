class AddIndexesForOpinions < ActiveRecord::Migration
  def self.up
    add_index :opinions, :tweet_id
    add_index :opinions, :rating
  end

  def self.down
    remove_index :opinions, :tweet_id
    remove_index :opinions, :rating
  end
end
