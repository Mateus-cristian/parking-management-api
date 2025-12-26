# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Parking API GET', type: :request do
  include Rack::Test::Methods

  def app
    App
  end

  let(:parking_repo) { instance_double(Repositories::ParkingRepository) }
  let(:parking_obj) do
    Entities::Parking.new(id: '123', plate: 'ABC-1234', paid: false, left: false,
                          created_at: Time.now)
  end

  let(:plate_scenarios) do
    {
      'ABC-1234' => { exists: true, history: [parking_obj] },
      'ABC-0000' => { exists: true, history: [] },
      'NON-EXISTENTID' => { exists: false, history: [] }
    }
  end

  before do
    allow(Repositories::ParkingRepository).to receive(:new).and_return(parking_repo)
    allow(parking_repo).to receive(:find_history_by_plate) do |plate|
      normalized = plate.to_s.upcase.delete('-').strip
      formatted = normalized.insert(3, '-')
      scenario = plate_scenarios[formatted] || { exists: false, history: [] }
      raise Errors::NotFoundError unless scenario[:exists]

      scenario[:history]
    end
  end

  describe 'GET /v1/parking/:id' do
    let(:headers) do
      { 'CONTENT_TYPE' => 'application/json', 'HTTP_IDEMPOTENCY_KEY' => 'unique-key' }
    end

    it 'returns 404 if plate does not exist' do
      get '/v1/parking/NON-EXISTENTID'
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)['error']).to eq('Resource not found')
    end

    it 'returns parking entry if found' do
      get '/v1/parking/ABC-1234'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body).to be_an(Array)
      expect(body[0]['plate']).to eq('ABC-1234')
    end

    it 'returns empty array if plate exists but no history' do
      allow(parking_repo).to receive(:plate_exists?).with('ABC-0000').and_return(true)
      allow(parking_repo).to receive(:find_history_by_plate) do |plate|
        normalized = plate.to_s.upcase.delete('-').strip
        formatted = normalized.insert(3, '-')
        case formatted
        when 'ABC-0000'
          []
        when 'ABC-1234'
          [parking_obj]
        else
          raise Errors::NotFoundError
        end
      end
      # Simula a existência da placa 'ABC-0000' na consulta do controller
      fake_collection = double('collection')
      fake_find = double('find')
      fake_limit = double('limit')
      allow(fake_collection).to receive(:find).and_return(fake_find)
      allow(fake_find).to receive(:limit).and_return(fake_limit)
      allow(fake_limit).to receive(:count).and_return(1)
      allow(parking_repo)
        .to receive(:instance_variable_get)
        .with(:@collection)
        .and_return(fake_collection)
      get '/v1/parking/ABC-0000'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([])
    end
  end
end
