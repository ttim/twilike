class MovieUpdater
  JOB_KOEF = 0.5
  JOB_PRIORITY = 2
  JOB_MIN_DAYS = 1.minute
  JOB_MAX_DAYS = 20.day

  def initialize(movie_id)
    @movie_id = movie_id
  end

  def perform
    movie = Movie.find(@movie_id)

    movie.update_info(Omdb.movie_info(movie.imdb_id))
    movie.save!

    # calc time to add
    delta = (Time.now - movie.created_at) * JOB_KOEF
    delta = JOB_MAX_DAYS if delta > JOB_MAX_DAYS
    delta = JOB_MIN_DAYS if delta < JOB_MIN_DAYS
    
    unless (Delayed::Job.enqueue(self, JOB_PRIORITY, Time.now+delta))
      raise "add new job not successful"
    end

    true
  end
end