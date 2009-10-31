class OpinionsController < ApplicationController
  TIMELINE_COUNT = 5
  TOP_COUNT = 5
  USER_TOP_COUNT = 7
  
  MOVIE_COUNT = 9
  USER_COUNT = 9

  TIMES = ["alltime", "year", "month", "week"] # TODO: add day
  
  # get movie by id
  def by_movie
    return if caching(1.minute, params[:small_name], params[:page])

    @movie = Movie.find_by_small_name(params[:small_name])

    if @movie != nil
      get_header_and_title_from_i18n
      @header = @movie.translated_name
      @title = @movie.translated_name + " (" + @movie.year.to_s + ")" + " / Twilike" 

      @opinions = Opinion.paginate(:conditions => { :movie_id => @movie },
                                   :per_page => MOVIE_COUNT,
                                   :page => params[:page])
    else
      redirect_to root_url
    end
  end

  # get movies timeline
  def timeline
    return if caching(1.minute)

    get_header_and_title_from_i18n
    
    @timelines = {}

    [[:plus, 1], [:minus, -1], [:neutral, 0]].each do |rate|
      @timelines[rate[0]] = Opinion.all(:limit => TIMELINE_COUNT,
                                        :conditions => { :rating => rate[1] })
    end
  end

  # get top movies
  def top
    get_header_and_title_from_i18n

    # find in names
    tmp = params[:time]
    @time = nil
    TIMES.each do |interval|
      @time = interval if tmp == interval
    end

    @time = @time || "month"

    return if caching(3.minutes, @time)

    # init header
    @header += " <span class = 'additional'> "+t("top.for")+" "
    TIMES.each do |interval|
      text = t("top.intervals."+interval)

      if interval == @time
        @header += text
      else
        @header += "<a href = '"+url_for(:time => interval)+"'>"+text+"</a>"
      end

      @header += ", " if interval != TIMES[TIMES.length-1]
    end
    @header += "</span>"

    @time_interval = {"alltime" => nil, "year" => 1.year, "month" => 1.month, "week" => 1.week, "day" => 1.day }[@time]

    @top_movies = Movie.top(TOP_COUNT, @time_interval)
    @worst_movies = Movie.worst(TOP_COUNT, @time_interval)
    @top_users = User.top(USER_TOP_COUNT, @time_interval)
  end

  # get movies by user
  def by_user
    # getting view
    @view = nil
    USER_VIEWS.each { |view| @view = view if params[:view] == view }

    # redirect if view = nil
    if @view == nil
      # get default view from cookies
      new_view = 'block' # default view
      USER_VIEWS.each { |view| new_view = view if cookies[:view] == view }

      head :moved_permanently,
           :location => user_movies_url(:screen_name => params[:screen_name], :page => params[:page], :view => new_view)

      return
    end

    # set current view as default
    cookies[:view] = { :value => @view, :expires => 1.year.from_now, :domain => "."+RAILS_DOMAIN }

    # it's all true
    return if caching(3.minutes, params[:screen_name], params[:page], @view)

    @user = User.first(:conditions => { :screen_name => params[:screen_name] })

    if @user != nil
      get_header_and_title_from_i18n
      @header = @user.name
      @title = @user.name + " / Twilike"
      
      @opinions = Opinion.paginate(:conditions => { :user_id => @user },
                                   :per_page => USER_COUNT,
                                   :page => params[:page])
    else
      redirect_to root_url
    end
  end

  def one
    @opinion = Opinion.find_by_tweet_id(params[:tweet_id])
  end
end
