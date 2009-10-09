module MovieHelper
  def rating(_rating)
    return "-.-" if _rating == nil

    return "10" if _rating == 10
    
    sprintf("%.1f", _rating) 
  end
end