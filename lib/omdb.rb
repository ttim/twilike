class Omdb
  API_KEY = 'jj8tf8rknh4z5h5q2lr2fyd7'
  BASE_URI = 'http://omdb.heroku.com'

  include HTTParty
  base_uri  BASE_URI

  def self.movie_info(imdb_id)
    result = self.get('/movie/'+imdb_id.to_s+".json", { :query => { :api_key => API_KEY } })

    raise "deleted" if result["result"] == "deleted"
    raise "movie not exist" if result["result"] == "movie not exist"

    result["movie"]
  end

  def self.movie_by_name(name)
    self.get('/movie', { :query => {:name => name, :api_key => API_KEY}, :format => :json })
  end

  def self.add_name_to_moderate(name)
    self.post('/movies', { :query => {:api_key => API_KEY}, :body => {:name => name}})
  end

  def self.weekend
    self.get('/movies/week', { :query => {:name => name, :api_key => API_KEY}, :format => :json })
  end
end