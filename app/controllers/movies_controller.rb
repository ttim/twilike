class MoviesController < ApplicationController
  MOVIES_COUNT = 12
  USERS_COUNT = 7

  # get movies for search
  def search
    @text = params[:q] || ""

    @header =(t "search.search")+ ": " + @text
    @title = @header + " / Twilike"

    movie_condition = ["UPPER(names) LIKE UPPER(?)", "%#{@text}%"]
    user_condition = ["UPPER(name) LIKE UPPER(?) OR UPPER(screen_name) LIKE UPPER(?)", "%#{@text}%", "%#{@text}%"]

    @movies_count = Movie.count(:conditions => movie_condition)
    @users_count = User.count(:conditions => user_condition)

    @type = "movie"
    @type = "user" if params[:target] == "user"

    if @type == "movie"
      @movies = Movie.paginate(:conditions => movie_condition,
                               :per_page => MOVIES_COUNT,
                               :page => params[:page])
    else
      @users = User.paginate(:conditions => user_condition,
                             :per_page => USERS_COUNT,
                             :page => params[:page])
    end

    render :layout => 'opinions'
  end

  def weekend
    return true if caching(3.hours)

    get_header_and_title_from_i18n

    @movies = Movie.weekend
    
    render :layout => 'opinions'
  end
end