class MovieCell < Cell::Base
  def initialize(*args)
    super

    @movie = @opts[:movie]
  end

  def for_search
    @rate_image = 'twilike/plus.png'
    @rate_count = @movie.plus_count

    render :view => 'for_top'
  end

  def for_info
    render
  end

  def for_best_top
    @time_interval = @opts[:time_interval]

    @rate_image = 'twilike/plus.png'
    @rate_count = @movie.plus_count(@time_interval)

    render :view => 'for_top'
  end

  def for_worst_top
    @time_interval = @opts[:time_interval]

    @rate_image = 'twilike/minus.png'
    @rate_count = @movie.minus_count(@time_interval)

    render :view => 'for_top'
  end
end