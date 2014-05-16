require 'rubygems'

ENV["RACK_ENV"] ||= 'test'

require 'rack/test'
require 'simplecov'
require 'simplecov-rcov'
require 'grape/rabl'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.root ENV["CIRCLE_ARTIFACTS"] if ENV["CIRCLE_ARTIFACTS"]
SimpleCov.start do
  add_filter "/config/"
  add_filter "/spec/"
end

require File.expand_path("../../config/environment", __FILE__)


RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rspec
  config.expect_with :rspec
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always){example.run}
  end
end

# require 'capybara/rspec'
# Capybara.configure do |config|
#   config.app = Axess::API
#   config.server_port = 9293
# end
