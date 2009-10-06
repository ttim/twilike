class CommonController < ApplicationController
  def set_view
    cookies[:view] = params[:view]

    redirect_to (params[:back] || root_url)
  end

  def work_off
    Delayed::Job.work_off(3)

    render :text => "work off"
  end
end
