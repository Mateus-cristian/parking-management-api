# frozen_string_literal: true

module V1
  module ParkingController
    def self.registered(app)
      register_post_parking(app)
      register_get_parking(app)
      put_parking_checkout(app)
    end

    def self.register_post_parking(app)
      app.post '/v1/parking' do
        body = JSON.parse(request.body.read)
        idempotency_key = request.env['HTTP_IDEMPOTENCY_KEY']

        parking_data = Services::ParkingEntryService.new.call(
          plate: body['plate'],
          idempotency_key: idempotency_key
        )

        status 201
        { id: parking_data[:id] }.to_json
      end
    end

    def self.register_get_parking(app)
      app.get '/v1/parking/:id' do
        parking = Repositories::ParkingRepository.new.find_by_id(params['id'])
        raise Errors::NotFoundError unless parking

        status 200
        parking.to_json
      end
    end

    def self.put_parking_checkout(app)
      app.put '/v1/parking/:id/checkout' do
        idempotency_key = request.env['HTTP_IDEMPOTENCY_KEY']

        Services::ParkingCheckoutService.new.call(
          id: params['id'],
          idempotency_key: idempotency_key
        )
        status 204
      end
    end
  end
end
