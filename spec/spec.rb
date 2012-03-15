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
        Service.lookup_service(string.to_s)
      end
      run SandwhichMaker
    end
  end

  it "does stuff" do
    visit SandwhichMaker::BASE_URL
  end

end