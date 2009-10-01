require "httparty"

class ImageProcessor
  API_KEY = "hkdja73badf723"

  format "json"

  include HTTParty

  base_uri "http://static.twilike.net/img"

  def self.store_image(url, short_name, width, height)
    result = self.post('/upload', {:body => {}, :query => { :key => API_KEY, :url => url, :shortcut => short_name, :note => url, :width => width, :height => height}})

    return false if result == nil

    result["result"] == "ok"
  end

  def self.get_image_href(short_name, width, height)
    base_uri+'/'+width.to_s+'/'+height.to_s+'/'+short_name+'.jpeg'
  end
end