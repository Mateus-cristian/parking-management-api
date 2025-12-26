# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking API GET', type: :request do
  include Rack::Test::Methods

  def app
    App
  end

  let(:parking_repo) { instance_double(Repositories::ParkingRepository) }

  before do
    allow(Repositories::ParkingRepository).to receive(:new).and_return(parking_repo)
  end

  describe 'GET /v1/parking/:id' do
    let(:headers) do
      { 'CONTENT_TYPE' => 'application/json', 'HTTP_IDEMPOTENCY_KEY' => 'unique-key' }
    end

    it 'returns 404 if parking entry not found' do
      allow(parking_repo).to receive(:find_by_id).with('nonexistentid').and_return(nil)
      get '/v1/parking/nonexistentid', {}, headers
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error'])
        .to eq('Parking entry not found')
    end

    it 'returns parking entry if found' do
      allow(parking_repo).to receive(:find_by_id).with('123').and_return({ 'plate' => 'ABC-1234',
                                                                           'id' => '123' })
      get '/v1/parking/123', {}, headers
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['plate']).to eq('ABC-1234')
    end
  end
end
