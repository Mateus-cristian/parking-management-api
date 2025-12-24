$LOAD_PATH.unshift(File.expand_path('../../app', __dir__))
ENV['APP_ENV'] = 'test'
require_relative '../app/application'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
