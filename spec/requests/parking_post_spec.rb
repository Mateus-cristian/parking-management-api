# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking API POST', type: :request do
  include Rack::Test::Methods

  def app
    App
  end

  let(:parking_repo) { instance_double(Repositories::ParkingRepository) }
  let(:parking_service) { instance_double(Services::ParkingEntryService) }

  before do
    allow(Repositories::ParkingRepository).to receive(:new).and_return(parking_repo)
    allow(Services::ParkingEntryService).to receive(:new).and_return(parking_service)
  end

  describe 'POST /v1/parking' do
    let(:headers) do
      { 'CONTENT_TYPE' => 'application/json', 'HTTP_IDEMPOTENCY_KEY' => 'unique-key' }
    end

    it 'creates a parking entry with valid plate' do
      allow(parking_service).to receive(:call).and_return({ 'plate' => 'ABC-1234', 'id' => '123' })
      post '/v1/parking', { plate: 'ABC-1234' }.to_json, headers
      expect(last_response.status).to eq(201)
      expect(JSON.parse(last_response.body)['plate']).to eq('ABC-1234')
    end

    it 'returns 422 for invalid plate' do
      allow(parking_service).to receive(:call).and_raise(Errors::InvalidPlateError.new)
      post '/v1/parking', { plate: '123-ABCD' }.to_json, headers
      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)['error'])
        .to eq('Invalid plate format. Expected AAA-9999')
    end
  end
end
