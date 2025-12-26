# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking Management API' do
  include Rack::Test::Methods

  def app
    App
  end

  it 'responds with ok status on /health' do
    get '/health'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('{"status":"ok"}')
  end
end
