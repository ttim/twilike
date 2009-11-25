class RestUserController < ApplicationController
  def seen_movies
	imdb_ids = User.find_by_screen_name(params[:screen_name]).opinions.collect { |opinion| opinion.movie.imdb_id }
	
	respond_to do |format|
		format.json { render :json => imdb_ids.to_json }
	end
  end
end
