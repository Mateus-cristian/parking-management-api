# frozen_string_literal: true

module Services
  class ParkingCheckoutService
    def initialize(
      parking_repo = Repositories::ParkingRepository.new,
      idempotency_service = Services::IdempotencyService.new
    )
      @parking_repo = parking_repo
      @idempotency_service = idempotency_service
    end

    def call(id:, idempotency_key:)
      parking_entity = @parking_repo.find_by_id(id)
      raise Errors::NotFoundError unless parking_entity

      parking = Entities::Parking.from_document(parking_entity.to_hash)
      parking.mark_as_left

      @idempotency_service.execute(idempotency_key) do
        @parking_repo.update(parking)
        parking
      end
    end
  end
end
