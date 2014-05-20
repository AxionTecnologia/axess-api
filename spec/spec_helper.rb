require 'rubygems'

ENV["RACK_ENV"] ||= 'test'

require 'rack/test'
require 'simplecov'
require 'simplecov-rcov'
require 'grape/rabl'

require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::RcovFormatter
]

SimpleCov.start do
  add_filter "/config/"
  add_filter "/spec/"
  add_filter "/vendor/"
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
