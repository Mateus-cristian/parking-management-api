# frozen_string_literal: true

require 'sinatra'
require_relative '../config/enviroment'
require_relative '../config/swagger'

class App < Sinatra::Base
  register SwaggerRoutes
  set :root, File.expand_path('..', __dir__)
  set :public_folder, File.join(root, 'public')

  get '/health' do
    content_type :json
    { status: 'ok' }.to_json
  end
end
