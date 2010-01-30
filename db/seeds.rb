# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Jobs
# 1) Twitter updater
Delayed::Job.enqueue(TwitterUpdater.new, TwitterUpdater::JOB_PRIORITY, Time.now)
# 2) Cache cleaner
Delayed::Job.enqueue(CacheCleaner.new, CacheCleaner::JOB_PRIORITY, Time.now)

# Old tweets
def add_tweet(id)
  AddedTweet.create(:tweet_id => id)
end
["3641892622", "3641889216", "3641882433", "3432890947", "3377756399", "3292045230", "3291560505", "3291041292"].each do |id|
  add_tweet(id)
end # 5an's old tweets