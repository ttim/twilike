class GoogleTranslate
  include HTTParty

  base_uri 'http://ajax.googleapis.com/ajax/services/language'

  format :json

  def self.translate(text, language_pair)
    result = self.get("/translate", :query => { :q => text, :v => "1.0", :langpair => language_pair })

    raise "Error while parsing result" if (result == nil) || (result["responseData"] == nil) || (result["responseStatus"] != 200)

    result["responseData"]["translatedText"]
  end
end