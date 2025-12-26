# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv/load'

ENV['APP_ENV'] ||= 'development'

Bundler.require(:default, ENV['APP_ENV'])
Dotenv.load(".env.#{ENV['APP_ENV']}", '.env')

Dir[File.join(__dir__, '../app/**/*.rb')].each { |file| require file }
Dir[File.join(__dir__, '../app/errors/*.rb')].each { |file| require file }
