class AddIndexesForCaches < ActiveRecord::Migration
  def self.up
    add_index :caches, :key
  end

  def self.down
    remove_index :caches, :key
  end
end
