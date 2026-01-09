# frozen_string_literal: true

require_relative '../../handlers/error_handlers'

module V1
  class ParkingController < Sinatra::Base
    register ErrorHandlers
    set :show_exceptions, false

    post '/v1/parking' do
      body = JSON.parse(request.body.read)
      idempotency_key = request.env['HTTP_IDEMPOTENCY_KEY']

      parking_data = Services::ParkingEntryService.new.call(
        plate: body['plate'],
        idempotency_key: idempotency_key
      )

      status 201
      { id: parking_data[:id] }.to_json
    end

    get '/v1/parking/:plate' do
      raw_plate = params['plate'].to_s.upcase.delete('-').strip
      formatted_plate = raw_plate.insert(3, '-')

      repo = Repositories::ParkingRepository.new
      history = repo.find_history_by_plate(formatted_plate)

      if history.empty?
        plate_exists = repo.plate_exists?(formatted_plate)
        raise Errors::NotFoundError unless plate_exists

        content_type :json
        return JSON.pretty_generate([])

      end
      content_type :json
      JSON.pretty_generate(history.map(&:to_hash))
    end

    put '/v1/parking/:id/out' do
      idempotency_key = request.env['HTTP_IDEMPOTENCY_KEY']

      Services::ParkingCheckoutService.new.call(
        id: params['id'],
        idempotency_key: idempotency_key
      )

      status 204
    end

    put '/v1/parking/:id/pay' do
      idempotency_key = request.env['HTTP_IDEMPOTENCY_KEY']

      Services::ParkingPaymentService.new.call(
        id: params['id'],
        idempotency_key: idempotency_key
      )

      status 204
    end
  end
end
