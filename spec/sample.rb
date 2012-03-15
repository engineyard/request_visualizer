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

  class << self
    attr_accessor :implemented_services
  end
  self.implemented_services = []

  def self.inherited(klass)
    Service.implemented_services << klass
    super(klass)
  end

  def self.lookup_service(service_url)
    Service.implemented_services.each do |service|
      if service_url.match service.const_get("BASE_URL")
        return service.to_s
      end
    end
    service_url
  end

end

class SandwhichMaker < Service

  BASE_URL = "https://sandwhichmaker.example.com/"

  post "/" do
    {}.to_json
  end

end



