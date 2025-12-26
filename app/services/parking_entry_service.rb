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

      existing = @parking_repo.find_open_by_plate(normalized_plate)
      raise Errors::CarAlreadyInParkingError if existing

      @idempotency_service.execute(idempotency_key) do
        parking = Entities::Parking.new(plate: normalized_plate)
        created = @parking_repo.create(parking)
        { id: created.id }
      end
    end
  end
end
