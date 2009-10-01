class CommonController < ApplicationController
  def set_lang
    cookies[:locale] = params[:lang]

    redirect_to (params[:back] || root_url)
  end

  def set_view
    cookies[:view] = params[:view]

    redirect_to (params[:back] || root_url)
  end

  def set_theme
    cookies[:theme] = params[:theme]

    redirect_to (params[:back] || root_url)
  end

  def work_off
    Delayed::Job.work_off(3)

    render :text => "work off"
  end
end
