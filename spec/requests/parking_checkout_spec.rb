# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe 'Parking API CHECKOUT', type: :request do
  include Rack::Test::Methods

  def app
    App
  end

  let(:checkout_service) { instance_double(Services::ParkingCheckoutService) }

  before do
    allow(Services::ParkingCheckoutService).to receive(:new).and_return(checkout_service)
  end

  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_IDEMPOTENCY_KEY' => 'test-key' } }

  it 'marks parking as left and returns 204' do
    allow(checkout_service).to receive(:call).and_return(true)
    put '/v1/parking/507f1f77bcf86cd799439011/out', nil, headers
    expect(last_response.status).to eq(204)
  end

  it 'returns 400 if not paid' do
    allow(checkout_service).to receive(:call).and_raise(Errors::NotPaidError.new)
    put '/v1/parking/507f1f77bcf86cd799439012/out', nil,
        headers.merge('HTTP_IDEMPOTENCY_KEY' => 'test-key-2')
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)['error']).to match(/Payment required/)
  end

  it 'returns 404 if not found' do
    allow(checkout_service).to receive(:call).and_raise(Errors::NotFoundError.new)
    put '/v1/parking/000000000000000000000000/out', nil,
        headers.merge('HTTP_IDEMPOTENCY_KEY' => 'test-key-3')
    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)['error']).to match(/not found/i)
  end
end
