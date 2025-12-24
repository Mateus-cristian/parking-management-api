# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking Management API' do
  include Rack::Test::Methods

  def app
    App
  end

  it 'responde com status ok no /health' do
    get '/health'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('{"status":"ok"}')
  end
end
