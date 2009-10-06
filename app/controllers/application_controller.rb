# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  USE_CACHE = (RAILS_ENV == "production")

  DOMAINS = { 'development' => 'twiliked.net', 'production' => 'twilike.net' }

  RAILS_DOMAIN = DOMAINS[RAILS_ENV]
  RAILS_PORT = (if (RAILS_ENV == "development") then ":3000" else "" end)

  LANGUAGES = ["ru", "en"]
  USER_VIEWS = ["block", "line"]

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_domain
  after_filter :save_to_cache

  def self.change_language(url, language)
    tmp = url.from(7)
    tmp = tmp.from(tmp.index("/"))

    "http://"+language+"."+RAILS_DOMAIN+RAILS_PORT+tmp
  end

  def check_domain
    current = nil

    LANGUAGES.each { |lang| current = lang if lang+"."+RAILS_DOMAIN == request.host }

    if (!current)
      # get cookie language
      language = 'ru' # default language
      LANGUAGES.each { |lang| language = lang if cookies[:locale] == lang }

      redirect_to_full_url(ApplicationController.change_language(request.url, language), 301)
    else
      I18n.locale = current

      cookies[:locale] = { :value => current, :expires => 1.year.from_now, :domain => "."+RAILS_DOMAIN }
    end
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def get_header_and_title_from_i18n
    action = request.parameters["action"]

    @title = t(action+".title")
    @header = t(action+".header")
  end

  def caching(time, *args)
    separator = "|||"

    @_time = time

    @_key = I18n.locale.to_s+separator+
            request.parameters["controller"]+separator+
            request.parameters["action"]

    args.each { |arg| @_key += separator+arg if arg != nil }

    result = Cache.get(@_key)
    if USE_CACHE && (result != nil)
      response.headers['Cache-Control'] = 'public, max-age='+time.to_i.to_s
      render :text => result

      @cached = true
      return true
    end

    @cached = false
    false
  end

  def save_to_cache
    Cache.set(@_key, @_time, response.body) if (!@cached) && (USE_CACHE) && (@_key != nil)
  end
end
