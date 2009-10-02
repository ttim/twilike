class Movie < ActiveRecord::Base
  has_many :opinions

  validates_presence_of :imdb_id, :message => "imdb id is required!"
  validates_uniqueness_of :imdb_id, :message => "imdb id is unique!"

  after_create :add_info_and_movie_job

  def add_info_and_movie_job
    # 1) add info
    update_info(Omdb.movie_info(self.imdb_id))
    self.save!
    # 2) add job
    Delayed::Job.enqueue(MovieUpdater.new(self.id), MovieUpdater::JOB_PRIORITY, Time.now+MovieUpdater::JOB_MIN_DAYS)
    # TODO: if enqueue not successul ??? O_O
  end

  def small_name_for(english_name)
    tmp = ""

    english_name.downcase.each_char do |char|
      ok = false
      "qwertyuiopasdfghjklzxcvbnm1234567890".each_char { |t| ok = (ok || (t == char)) }
      tmp += "-" if char == " "
      tmp += char if ok
    end

    movie = Movie.find_by_small_name(tmp)

    if (movie == nil) || (movie == self)
      return tmp
    end

    1000.times do |num|
      movie = Movie.find_by_small_name(tmp+"-"+num.to_s)

      if (movie == nil) || (movie == self)
        return tmp+"-"+num.to_s
      end
    end

    raise "Error with small name!"
  end

  def update_saved_image
    # open(RAILS_ROOT+"/public/tmp/"+self.small_name+".jpeg", 'wb') { |file| file.write(UrlFetch.get(self.image_url).body) }
    self.image_url = nil if self.image_url == ""

    if self.image_url != nil
      Delayed::Job.enqueue(CreateThumbs.new(self.small_name, self.image_url),
                         CreateThumbs::JOB_PRIORITY, Time.now)
    end
  end

  def update_info(info)
    self.original_name = info["original_name"]
    self.russian_name = info["russian_name"]
    self.english_name = info["english_name"]

    self.small_name = small_name_for(info["english_name"])

    self.russian_tagline = info["russian_tagline"]
    self.english_tagline = info["english_tagline"]

    self.year = info["year"]

    if info["image_url"] != self.image_url
      self.image_url = info["image_url"]
      # update saved image - /movies/original/small_name.jpeg
      # /movies/medium/ /movies/small
      update_saved_image
    end

    names = "|"
    info["names"].each { |name| names += name + "|" }

    self.names = names
  end

  def translated_name
    name = nil
    
    name = self.russian_name if I18n.locale == "ru"
    name = self.english_name if I18n.locale == "en"

    name = self.original_name if name == nil

    name
  end

  def translated_tagline
    return self.russian_tagline if I18n.locale == "ru"

    self.english_tagline
  end

  def imdb_href
    "http://imdb.com/title/tt"+self.imdb_id.to_s
  end

  def opinions_by_rating(rating, time_interval)
    return Opinion.count(:conditions => {:movie_id => self, :rating => rating} ) if time_interval == nil

    Opinion.count(:conditions => ["movie_id = :movie_id AND rating = :rating AND created_at > :min_created_at",
                                  {:movie_id => self, :rating => rating, :min_created_at => Time.now-time_interval}])
  end

  def plus_count(time_interval = nil)
    opinions_by_rating(1, time_interval)
  end

  def neutral_count(time_interval = nil)
    opinions_by_rating(0, time_interval)
  end

  def minus_count(time_interval = nil)
    opinions_by_rating(-1, time_interval)
  end

  def self.top_by_rating(order, count, time_interval)
    if time_interval == nil
      condition = { }
    else
      condition = ["created_at > :min_created_at",
                   { :min_created_at => Time.now-time_interval}]
    end

    result = []

    Opinion.find(:all, :select => "movie_id, movie_id as created_at",
                 :conditions => condition,
                 :group => "movie_id",
                 :order => "avg(rating) "+order+", count(id) "+order,
                 :having => "count(id) > 1",
                 :limit => count).each { |movie| result << Movie.find(movie.movie_id) }

    result
  end

  def self.top(count, time_interval)
    self.top_by_rating('DESC', count, time_interval)
  end

  def self.worst(count, time_interval)
    self.top_by_rating('ASC', count, time_interval)
  end

  def small_image_url
    return nil if (self.image_url == nil) # || (RAILS_ENV == "development")

    # from GAE
    ImageProcessor.get_image_href(self.small_name, 67, 50)
  end

  def medium_image_url
    return nil if (self.image_url == nil) # || (RAILS_ENV == "development")

    # from GAE
    ImageProcessor.get_image_href(self.small_name, 260, 195)
  end

  def big_image_url
    return nil if (self.image_url == nil) # || (RAILS_ENV == "development")

    # from GAE
    ImageProcessor.get_image_href(self.small_name, 450, 337)
  end
end