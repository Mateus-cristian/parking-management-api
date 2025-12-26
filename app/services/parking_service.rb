# frozen_string_literal: true

module Services
  class ParkingEntryService
    def initialize(
      parking_repo = Repositories::ParkingRepository.new,
      idempotency_service = Services::IdempotencyService.new
    )
      @parking_repo = parking_repo
      @idempotency_service = idempotency_service
    end

    def call(plate:, idempotency_key:)
      normalized_plate = Validators::PlateValidator.validate!(plate)

      @idempotency_service.execute(idempotency_key) do
        parking = Entities::Parking.new(plate: normalized_plate)
        @parking_repo.create(parking).to_hash
      end
    end
  end
end
