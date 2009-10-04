class UserCell < Cell::Base

  def for_top
    @user = @opts[:user]
    @time_interval = @opts[:time_interval]

    render
  end
end
