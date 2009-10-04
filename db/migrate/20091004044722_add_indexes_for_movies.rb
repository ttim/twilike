class AddIndexesForMovies < ActiveRecord::Migration
  def self.up
    add_index :movies, :small_name
  end

  def self.down
    remove_index :movies, :small_name
  end
end
