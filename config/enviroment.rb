# frozen_string_literal: true

require 'dotenv/load'

ENV['APP_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['APP_ENV'])
