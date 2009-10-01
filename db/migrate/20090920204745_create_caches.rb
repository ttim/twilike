class CreateCaches < ActiveRecord::Migration
  def self.up
    create_table :caches do |t|
      t.string :key
      t.timestamp :delete_at
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :caches
  end
end
