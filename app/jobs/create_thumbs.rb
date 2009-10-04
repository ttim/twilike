class CreateThumbs
  JOB_PRIORITY = 10

  def initialize(short_name, url)
    @short_name = short_name
    @url = url
  end

  def perform
    Movie::IMAGE_SIZES.each do |size|
      raise "Thumbs not created!" unless ImageProcessor.store_image(@url, @short_name, size[:width], size[:height])
    end
    
    true
  end
end