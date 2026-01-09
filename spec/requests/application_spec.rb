# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking Management API' do
  include Rack::Test::Methods

  def app
    App
  end

  it 'responds with ok status on /health' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to include('application/json')
    expect(JSON.parse(last_response.body)['status']).to include('project running')
  end
end
