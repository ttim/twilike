class DeleteDataColumn < ActiveRecord::Migration
  def self.up
    remove_column :added_tweets, :data
  end

  def self.down
    add_column :added_tweets, :data, :text
  end
end
