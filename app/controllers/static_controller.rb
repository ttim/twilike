class StaticController < ApplicationController
  def about
    if caching(5.minutes)
      return
    end

    get_header_and_title_from_i18n

    render :layout => 'opinions'
  end

  def message
    if caching(5.minutes)
      return
    end

    get_header_and_title_from_i18n

    render :layout => 'opinions'
  end
end
