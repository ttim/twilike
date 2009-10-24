class StaticController < ApplicationController
  def static(name)
    return true if caching(5.minutes)
    
    get_header_and_title_from_i18n

    render 'static/'+I18n.locale.to_s+'/'+name, :layout => 'opinions'

    return false
  end

  def about
    return if static('about')
  end

  def message
    return if static('message')
  end
end