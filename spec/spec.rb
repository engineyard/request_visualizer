require File.expand_path("../sample", __FILE__)
require 'request_visualizer'
require 'capybara/rspec'

RSpec.configure do |config|
  config.include(Capybara::RSpecMatchers)
  config.include(Capybara::DSL)
end

describe "things" do
  before do
    Capybara.app = Rack::Builder.new do
      use RequestVisualizer do |string|
        Lookup.lookup(string.to_s)
      end
      Lookup.services.each do |url, service|
        map url do
          run service
        end
      end
    end
    page.driver.header 'User-Agent', "Capybara"
  end

  it "makes a sandwhich" do
    visit SandwhichMaker::BASE_URL
  end

end