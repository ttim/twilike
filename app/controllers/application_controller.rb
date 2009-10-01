# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  USE_CACHE = (RAILS_ENV == "production")
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :sets
  after_filter :save_to_cache

  def sets
    _set_locale
    _set_view
    _set_theme
  end
  
  def _set_locale
    ["ru", "en"].each do |lang|
      if cookies[:locale] == lang
        I18n.locale = lang
        return
      end
    end

    I18n.locale = "ru"
  end

  def _set_view
    ["block", "line"].each do |view|
      if cookies[:view] == view
        @view = view
        return
      end
    end

    @view = "block" # default
  end

  def _set_theme
    ["theme1", "theme2"].each do |theme|
      if cookies[:theme] == theme
        @theme = theme
        return
      end
    end

    @theme = "theme1" # default
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
           request.parameters["action"]+separator+
           @theme

    args.each { |arg| @_key += separator+arg  if arg != nil }

    result = Cache.get(@_key)
    if USE_CACHE && (result != nil)
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
