class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer :imdb_id, :null => false
      t.string :original_name
      t.string :russian_name
      t.string :english_name

      t.string :small_name
      
      t.integer :year
      t.string :russian_tagline
      t.string :english_tagline

      t.string :image_url
      
      t.text :names

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
