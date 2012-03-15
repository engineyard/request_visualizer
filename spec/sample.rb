require 'ey_api_hmac'
class Connection < EY::ApiHMAC::BaseConnection

  def initialize(user_agent, app)
    super(user_agent)
    self.backend = app
  end

  def get(url)
    super(url) do |json_body, location|
      json_body
    end
  end

  def post(url, params)
    super(url, params) do |json_body, location|
      json_body
    end
  end

end

require 'sinatra/base'
class Service < Sinatra::Base
  enable :raise_errors
  disable :dump_errors
  disable :show_exceptions

  def conn
    @conn ||= Connection.new(self.class.to_s, Capybara.app)
  end
end

class Lookup
  def self.services
    @services ||= {}
  end

  def self.lookup(service_url)
    services.each do |base_url, service|
      if service_url.match base_url
        return service.to_s
      end
    end
    service_url
  end

end

class SandwhichMaker < Service
  BASE_URL = "https://sandwhichmaker.example.com/"
  Lookup.services[BASE_URL] = self

  get "/" do
    bread = conn.get("#{Baker::BASE_URL}get_loaf")
    conn.post("#{BreadSlicer::BASE_URL}slice", {:bread_url => bread["url"]})
    content_type "application/json"
    {:sandwhich => true}.to_json
  end

end

class BreadSlicer < Service
  BASE_URL = "https://breadslicer.example.com/"
  Lookup.services[BASE_URL] = self

  post "/slice" do
    post_body = JSON.parse(request.body.read)
    bread = conn.get(post_body["bread_url"])
    content_type "application/json"
    {:slices => ["heel","slice","slice","slice","heel"]}.to_json
  end

end

class Baker < Service
  BASE_URL = "https://bakery.example.com/"
  Lookup.services[BASE_URL] = self

  get "/loaves/1" do
    content_type "application/json"
    {:type => "sourdough"}.to_json
  end

  get "/get_loaf" do
    content_type "application/json"
    {:url => "#{BASE_URL}loaves/1"}.to_json
  end

end



