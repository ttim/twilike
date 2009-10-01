# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  NO_IMAGE = 'no_image.jpg'

  def lang_link(language_name, language_locale)
    return language_name if language_locale == I18n.locale

    link_to language_name, change_url('lang', language_locale)
  end

  def navigation_link(action_name)
    text = t("common."+action_name)

    html = {}
    html = { :class => "active_tab" } if action_name == request.parameters["action"]

    if action_name == 'about'
      controller = 'static'
    else
      controller = 'opinions'
    end

    link_to text, { :controller => controller, :action => action_name }, html
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

  def user_href(user)
    link_to user.name, :controller => :opinions, :action => 'by_user', :screen_name => user.screen_name
  end

  def movie_href(movie)
    "<a class='movie_href' href='"+url_for(:controller => :opinions, :action => :by_movie, :small_name => movie.small_name)+"'>"+movie.translated_name+"</a>"
  end

  def movie_big_image_tag(movie)
    image = movie.big_image_url
    image = image_path(NO_IMAGE) if image == nil

    "<img alt='"+movie.translated_name+"' class = 'movie_img_big' id = 'movie_"+movie.small_name+"' src='"+image+"' />"
  end

  def movie_medium_image_tag(movie)
    image = movie.medium_image_url
    image = image_path(NO_IMAGE) if image == nil

    "<img alt='"+movie.translated_name+"' class = 'movie_img_medium' id = 'movie_"+movie.small_name+"' src='"+image+"' />"
  end

  def movie_small_image_tag(movie)
    image = movie.small_image_url
    image = image_path(NO_IMAGE) if image == nil

    "<img alt='"+movie.translated_name+"' class = 'movie_img_small' src='"+image+"' />"
  end

  def view_link(view_type)
    text = t("by_user."+view_type+"_view")

    puts "!"+view_type+" "+@view

    html = {}
    html = { :class => "active_tab" } if view_type == @view

    link_to text, change_url('view', view_type), html
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
    tmp = []
    args.each { |arg| tmp << (@theme+"/"+arg) }

    
    if RAILS_ENV == "production"
      stylesheet_link_tag('_'+@theme)
    else
      stylesheet_link_tag(tmp)
    end
  end

  def change_url(what, how)
    url_for("/set_"+what+"/"+how+"?back="+CGI::escape(request.url))
  end

  def comment_movie(movie, text = "@")
    name = movie.english_name
    name = name.gsub(/\./, '')

    link_to text, 'http://twitter.com/home?status='+CGI.escape(name+". "+t('message.your_opinion')+". #twilike+"), { :title => t('message.comment_movie')}
  end
end