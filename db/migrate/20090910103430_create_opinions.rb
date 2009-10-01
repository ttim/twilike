class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.string :tweet_id, :null => false
      
      t.integer :movie_id, :null => false, :options =>
        "CONSTRAINT fk_opinion_movies REFERENCES movies(id)"
      t.integer :user_id, :null => false, :options =>
        "CONSTRAINT fk_opinion_users REFERENCES user(id)"
      
      t.text :text
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :opinions
  end
end
