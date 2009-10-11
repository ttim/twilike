# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  NO_IMAGE = 'no_image.jpg'

  def lang_link(language_name, language_locale)
    return language_name if language_locale == I18n.locale

    link_to language_name, ApplicationController.change_language(request.url, language_locale)
  end

  def navigation_link(controller_name, action_name)
    text = t("common."+action_name)

    html = {}
    html = { :class => "active_tab" } if action_name == request.parameters["action"]

    link_to text, { :controller => controller_name, :action => action_name }, html
  end

  def image_for_rating(rating)
    image_path('twilike/'+{-1 => "minus", 0 => "neutral", 1 => "plus"}[rating]+'.png')
  end

  def rating_image(opinion)
    image_for_rating(opinion.rating)
  end

  def user_image_tag(user)
    "<img alt='"+user.name+"' height='48' src='"+user.profile_image_url+"' width='48'/>"
  end

  def user_name(user)
    name = user.name

    return user.screen_name if name == nil
    
    name = name.strip
    name = user.screen_name if name == ""

    name
  end

  def user_href(user)
    link_to (user_name(user)), :controller => :opinions, :action => 'by_user', :screen_name => user.screen_name
  end

  def movie_href(movie)
    "<a class='movie_href' href='"+url_for(:controller => :opinions, :action => :by_movie, :small_name => movie.small_name)+"'>"+movie.translated_name+"</a>"
  end

  def movie_image_tag(movie, size)
    image = movie.image_url_with_size(size)
    image = image_path(NO_IMAGE) if image == nil

    "<img alt='"+movie.translated_name+"' class = 'movie_img_"+size.to_s+"' id = 'movie_"+movie.small_name+"' src='"+image+"' />"
  end

  def view_link(view_type)
    text = t("by_user."+view_type+"_view")

    html = {}
    html = { :class => "active_tab" } if view_type == @view

    link_to text,
            user_movies_url(:screen_name => params[:screen_name], :page => params[:page], :view => view_type),
            html
  end

  def opinion_link(opinion)
    id = opinion.tweet_id
    url_for(opinion_url :tweet_id => id)
  end

  def main_css_link_tag(*args)
    tmp = []
    args.each { |arg| tmp << arg }

    if RAILS_ENV == "production"
      stylesheet_link_tag("_all")
    else
      stylesheet_link_tag(tmp)
    end
  end

  def colors_css_link_tag(*args)
    theme = "theme1" # it's default theme

    tmp = []
    args.each { |arg| tmp << (theme+"/"+arg) }

    if RAILS_ENV == "production"
      result = stylesheet_link_tag('_'+theme)
    else
      result = stylesheet_link_tag(tmp)

      result += '<script type="text/javascript">'

      files = []
      args.each { |arg| files << ("'"+arg+"'") }

      result += 'THEME_FILES = ['+files.join(",")+']'

      result += '</script>'
    end

    result
  end

  def rails_env_javascript
    '<script type="text/javascript">RAILS_ENV="'+RAILS_ENV+'"; RAILS_DOMAIN="'+ApplicationController::RAILS_DOMAIN+'"</script>'
  end

  def comment_movie(movie, text = "@")
    name = movie.english_name
    name = name.gsub(/\./, '')

    link_to text, 'http://twitter.com/home?status='+CGI.escape(name+". "+t('message.your_opinion')+". #twilike+"), { :title => t('message.comment_movie')}
  end
end