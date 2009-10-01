class Cache < ActiveRecord::Base
  validates_uniqueness_of :key

  def self.get(key)
    record = self.find_by_key(key)

    return nil if record == nil

    record.text
  end

  def self.set(key, time, text)
    record = self.find_or_create_by_key(key)

    record.delete_at = Time.now+time
    record.text = text

    record.save!
  end

  def self.clean
    self.delete_all(["delete_at < ?", Time.zone.now])
  end
end
