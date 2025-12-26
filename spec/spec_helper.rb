# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../../app', __dir__))
ENV['APP_ENV'] = 'test'
require_relative '../app/application'
require 'rack/test'
require 'factory_bot'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
