# frozen_string_literal: true

module V1
  module ParkingController
    def self.registered(app)
      register_post_parking(app)
      register_get_parking(app)
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
        parking_data.to_json
      end
    end

    def self.register_get_parking(app)
      app.get '/v1/parking/:id' do
        parking = Repositories::ParkingRepository.new.find_by_id(params['id'])
        if parking
          status 200
          parking.to_json
        else
          status 404
          { error: 'Parking entry not found' }.to_json
        end
      end
    end
  end
end
