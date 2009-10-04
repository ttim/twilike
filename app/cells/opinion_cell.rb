class OpinionCell < Cell::Base
  def initialize(*args)
    super

    @opinion = @opts[:opinion]
  end

  def for_movie
    render
  end

  def for_one_opinion
    render
  end

  def for_sidebar
    render
  end

  def for_timeline
    render
  end

  def for_top
    render
  end

  def for_user
    render :view => "for_user_"+@opts[:type].to_s
  end
end
