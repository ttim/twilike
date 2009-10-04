class AddIndexesForUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :screen_name
  end

  def self.down
    remove_index :users, :screen_name
  end
end
