class MovieCell < Cell::Base
  def for_search
    @movie = @opts[:movie]

    @rate_image = 'twilike/plus.png'
    @rate_count = @movie.plus_count

    render :view => 'for_top'
  end

  def for_info
    @movie = @opts[:movie]
    
    render
  end

  def for_best_top
    @movie = @opts[:movie]
    @time_interval = @opts[:time_interval]

    @rate_image = 'twilike/plus.png'
    @rate_count = @movie.plus_count(@time_interval)

    render :view => 'for_top'
  end

  def for_worst_top
    @movie = @opts[:movie]
    @time_interval = @opts[:time_interval]

    @rate_image = 'twilike/minus.png'
    @rate_count = @movie.minus_count(@time_interval)

    render :view => 'for_top'
  end
end
