class MovieCell < Cell::Base
  helper :movie
  
  def initialize(*args)
    super

    @movie = @opts[:movie]
  end

  def for_search
    @rating = @movie.calc_rating
    
    render :view => 'for_top'
  end

  def for_info
    render
  end

  def for_top
    @time_interval = @opts[:time_interval]

    @rating = @movie.calc_rating(@time_interval)

    render :view => 'for_top'
  end
end