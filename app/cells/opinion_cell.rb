class OpinionCell < Cell::Base
  def for_movie
    @opinion = @opts[:opinion]

    render
  end

  def for_one_opinion
    @opinion = @opts[:opinion]

    render
  end

  def for_sidebar
    @opinion = @opts[:opinion]

    render
  end

  def for_timeline
    @opinion = @opts[:opinion]

    render
  end

  def for_top
    @opinion = @opts[:opinion]

    render
  end

  def for_user
    @opinion = @opts[:opinion]
    
    render :view => "for_user_"+@opts[:type].to_s
  end
end
