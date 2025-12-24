require 'sinatra'
require_relative '../config/enviroment'

class App < Sinatra::Base
  get '/health' do
    content_type :json
    { status: 'ok' }.to_json
  end
end