require "mechanize"

class UrlFetch
  @@agent = WWW::Mechanize.new
  @@agent.user_agent_alias = 'Mac Safari'

  def self.get(url)
    page = @@agent.get url

    page
  end
end