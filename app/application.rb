# frozen_string_literal: true

require 'sinatra'
require_relative '../config/environment'
require_relative '../config/swagger'
require_relative 'controllers/v1/parking_controller'
require_relative 'handlers/error_handlers'

class App < Sinatra::Base
  register SwaggerRoutes
  register ErrorHandlers
  use V1::ParkingController

  set :root, File.expand_path('..', __dir__)
  set :public_folder, File.join(root, 'public')
  set :show_exceptions, false

  get '/' do
    content_type :json
    { status: 'project running 🚀' }.to_json
  end
end
