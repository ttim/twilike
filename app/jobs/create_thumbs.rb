class CreateThumbs
  JOB_PRIORITY = 2

  def initialize(short_name, url)
    @short_name = short_name
    @url = url
  end

  def perform
    unless (ImageProcessor.store_image(@url, @short_name, 260, 195) &&
            ImageProcessor.store_image(@url, @short_name, 67, 50) &&
            ImageProcessor.store_image(@url, @short_name, 450, 337))
      raise "Thumbs not created!"
    end

    true
  end
end