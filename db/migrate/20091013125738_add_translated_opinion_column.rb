class AddTranslatedOpinionColumn < ActiveRecord::Migration
  def self.up
    add_column :opinions, :translated_text, :text, :default => nil

    Opinion.all.each do |opinion|
      Delayed::Job.enqueue(OpinionTranslate.new(opinion), OpinionTranslate::JOB_PRIORITY, Time.now)
    end
  end

  def self.down
    remove_column :opinions, :translated_text

    Delayed::Job.all(:conditions => ["handler like ?", "%OpinionTranslate%"]).each { |job| job.delete }
  end
end
