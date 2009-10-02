class StaticController < ApplicationController
  def about
    return if caching(5.minutes)

    get_header_and_title_from_i18n

    render :layout => 'opinions'
  end

  def message
    return if caching(5.minutes)

    get_header_and_title_from_i18n

    render :layout => 'opinions'
  end
end